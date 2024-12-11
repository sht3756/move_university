import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_university_project/core/constants/enum/enum.dart';
import 'package:move_university_project/features/user_details/cubit/user_details_cubit.dart';
import 'package:move_university_project/features/user_details/cubit/user_details_state.dart';
import 'package:move_university_project/features/user_details/data/repositories/user_details_repository.dart';
import 'package:move_university_project/features/user_list/data/models/user_model.dart';
import 'package:move_university_project/shared/widgets/cupertino_confirm_dialog.dart';
import 'package:move_university_project/shared/widgets/user_card.dart';

import '../data/models/user_details_model.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserModel user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  UserCardMode currentMode = UserCardMode.view;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late DateTime registerDate;

  bool showEmailError = false;
  bool showPhoneError = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();

    // 에러 상태 리스너
    emailController.addListener(() {
      _updateErrorState(
        controller: emailController,
        isValid: _isEmailValid,
        setError: (value) => showEmailError = value,
      );
    });

    phoneController.addListener(() {
      _updateErrorState(
        controller: phoneController,
        isValid: _isPhoneValid,
        setError: (value) => showPhoneError = value,
      );
    });

    // 초기값 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = widget.user;
      nameController.text = user.name;
      phoneController.text = user.phone;
      emailController.text = user.email;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _updateErrorState({
    required TextEditingController controller,
    required bool Function(String) isValid,
    required void Function(bool) setError,
  }) {
    setState(() {
      setError(controller.text.isNotEmpty && !isValid(controller.text));
    });
  }

  bool _isNameValid(String name) => name.isNotEmpty && name.length >= 2;

  bool _isEmailValid(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _isPhoneValid(String phone) {
    final phoneRegex = RegExp(r'^010-\d{4}-\d{4}$');
    return phoneRegex.hasMatch(phone);
  }

  bool _isFormValid() {
    return _isNameValid(nameController.text) &&
        _isEmailValid(emailController.text) &&
        _isPhoneValid(phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.user;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserDetailsCubit(
              UserDetailsRepository(FirebaseFirestore.instance))
            ..fetchUserDetails(userName: userData.email),
        ),
      ],
      child: BlocConsumer<UserDetailsCubit, UserDetailsState>(
        listener: (BuildContext context, UserDetailsState state) {
          state.whenOrNull(error: (e, s) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          });
        },
        builder: (BuildContext context, UserDetailsState state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('상세페이지'),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: currentMode == UserCardMode.view
                      ? () {
                          setState(() {
                            currentMode = UserCardMode.edit;
                          });
                        }
                      : () {
                          if (_isFormValid()) {
                            final updateData = UserDetailsModel(
                              name: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              registerDate: registerDate,
                              modifiedDate: DateTime.now(),
                            );

                            context
                                .read<UserDetailsCubit>()
                                .updateUserDetails(updateData);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('수정에 성공했습니다.')),
                            );
                            currentMode = UserCardMode.view;
                            Navigator.pop(context, true);
                          }
                        },
                  child:
                      Text(currentMode == UserCardMode.view ? '수정하기' : '수정완료'),
                ),
                TextButton(
                  onPressed: () {
                    cupertinoConfirmDialog(
                      context,
                      title: 'Delete',
                      description: '해당 유저를 삭제 하시겠습니까?',
                      rightBtnAction: () {
                        context
                            .read<UserDetailsCubit>()
                            .deleteUserDetails(userData.email);
                        Navigator.pop(context, true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('삭제 성공하였습니다.')),
                        );
                      },
                    );
                  },
                  child: const Text('삭제하기'),
                )
              ],
            ),
            body: state.when(
              initial: () => const Center(child: Text('init')),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (UserDetailsModel data) {
                registerDate = data.registerDate;

                if (currentMode == UserCardMode.view) {
                  nameController.text = data.name;
                  phoneController.text = data.phone;
                  emailController.text = data.email;
                }

                return currentMode == UserCardMode.edit
                    ? _buildEditMode(data)
                    : _buildViewMode(data);
              },
              error: (e, s) => Center(child: Text('Error : $e')),
            ),
          );
        },
      ),
    );
  }

  Widget _buildViewMode(UserDetailsModel data) {
    return UserCard(
      nameController: nameController,
      emailController: emailController,
      phoneController: phoneController,
      mode: UserCardMode.view,
      onEditPressed: () {
        setState(() {
          currentMode = UserCardMode.edit;
        });
      },
    );
  }

  Widget _buildEditMode(UserDetailsModel data) {
    return UserCard(
      nameController: nameController,
      emailController: emailController,
      phoneController: phoneController,
      mode: UserCardMode.edit,
      showEmailError: showEmailError,
      showPhoneError: showPhoneError,
      onPhoneChanged: (value) {
        final formatted = value.replaceAllMapped(
            RegExp(r'(\d{3})(\d{4})(\d{4})'), (m) => '${m[1]}-${m[2]}-${m[3]}');
        phoneController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      },
    );
  }
}
