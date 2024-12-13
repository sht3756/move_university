import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_university_project/core/constants/enum/enum.dart';
import 'package:move_university_project/core/utils/format_time.dart';
import 'package:move_university_project/core/utils/valid_utils.dart';
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  late DateTime registerDate;
  late DateTime modifiedDate;

  bool showEmailError = false;
  bool showPhoneError = false;
  bool showNameError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = widget.user;
      nameController.text = user.name;
      phoneController.text = user.phone;
      emailController.text = user.email;
    });

    emailController.addListener(() {
      _updateErrorState(
        controller: emailController,
        isValid: isEmailValid,
        setError: (value) => showEmailError = value,
      );
    });

    phoneController.addListener(() {
      _updateErrorState(
        controller: phoneController,
        isValid: isPhoneValid,
        setError: (value) => showPhoneError = value,
      );
    });

    nameController.addListener(() {
      _updateErrorState(
        controller: nameController,
        isValid: isNameValid,
        setError: (value) => showNameError = value,
      );
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          setError(controller.text.isNotEmpty && !isValid(controller.text));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.user;

    return BlocProvider(
      create: (context) =>
          UserDetailsCubit(UserDetailsRepository(FirebaseFirestore.instance))
            ..fetchUserDetails(userName: userData.email),
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
                          if (isFormValid(nameController.text,
                              emailController.text, phoneController.text)) {
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
                modifiedDate = data.modifiedDate;

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
    return Column(
      children: [
        UserCard(
          nameController: nameController,
          emailController: emailController,
          phoneController: phoneController,
          mode: UserCardMode.view,
          onEditPressed: () {
            setState(() {
              currentMode = UserCardMode.edit;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('작성시간 : '),
                  Text(formatDateTime(registerDate.toIso8601String())),
                ],
              ),
              Row(
                children: [
                  const Text('수정시간 : '),
                  Text(formatDateTime(modifiedDate.toIso8601String())),
                ],
              ),
            ],
          ),
        )
      ],
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
      showNameError: showNameError,
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
