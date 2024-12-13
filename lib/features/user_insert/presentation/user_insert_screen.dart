import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_university_project/core/constants/enum/enum.dart';
import 'package:move_university_project/core/utils/format_phone_number.dart';
import 'package:move_university_project/core/utils/valid_utils.dart';
import 'package:move_university_project/features/user_details/data/models/user_details_model.dart';
import 'package:move_university_project/features/user_insert/cubit/user_insert_cubit.dart';
import 'package:move_university_project/shared/widgets/user_card.dart';

class UserInsertScreen extends StatefulWidget {
  const UserInsertScreen({super.key});

  @override
  State<UserInsertScreen> createState() => _UserInsertScreenState();
}

class _UserInsertScreenState extends State<UserInsertScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool showEmailError = false;
  bool showPhoneError = false;

  @override
  void initState() {
    super.initState();
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

  void _submitForm() {
    if (isFormValid(nameController.text, emailController.text, phoneController.text)) {
      context.read<UserInsertCubit>().insertUserDetails(
        UserDetailsModel(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          registerDate: DateTime.now(),
          modifiedDate: DateTime.now(),
        ),
      );
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.grey[200],
            title: const Text('사용자 추가'),
            centerTitle: true,
            leading: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            actions: [
              TextButton(
                onPressed: isFormValid(nameController.text, emailController.text, phoneController.text) ? _submitForm : null,
                child: const Text('완료'),
              ),
            ],
          ),
          body : UserCard(
            nameController: nameController,
            emailController: emailController,
            phoneController: phoneController,
            mode: UserCardMode.create,
            showEmailError: showEmailError,
            showPhoneError: showPhoneError,
            onPhoneChanged: (value) {
              final formatted = formatPhoneNumber(value);
              phoneController.value = TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
              setState(() {
                showPhoneError = value.isNotEmpty && !isPhoneValid(formatted);
              });
            },
          ),
        ),
      ),
    );
  }
}
