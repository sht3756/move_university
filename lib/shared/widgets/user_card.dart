import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:move_university_project/core/constants/enum/enum.dart';

import 'build_text_field.dart';

class UserCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final UserCardMode mode;
  final bool showEmailError;
  final bool showPhoneError;
  final bool showNameError;

  final void Function(String)? onPhoneChanged;
  final void Function()? onEditPressed;

  const UserCard({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.mode,
    this.showEmailError = false,
    this.showPhoneError = false,
    this.showNameError = false,
    this.onPhoneChanged,
    this.onEditPressed,
  });

  bool get isEditable => mode == UserCardMode.edit || mode == UserCardMode.create;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTextField(
              controller: nameController,
              label: '사용자 이름',
              prefixIcon: Icons.person_sharp,
              keyboardType: TextInputType.name,
              errorText: showNameError ? '2글자 이상으로 해주세요' : null,
              enabled: isEditable,
            ),
            const SizedBox(height: 10),
            buildTextField(
              controller: emailController,
              label: '이메일',
              prefixIcon: Icons.email,
              hintText: 'example@google.com',
              errorText: showEmailError ? '유효한 이메일 형식이 아닙니다.' : null,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
              ],
              keyboardType: TextInputType.emailAddress,
              enabled: mode == UserCardMode.create,
            ),
            const SizedBox(height: 10),
            buildTextField(
              controller: phoneController,
              label: '핸드폰 번호',
              prefixIcon: Icons.phone,
              hintText: '010-1234-0000',
              errorText: showPhoneError ? '유효한 전화번호 형식이 아닙니다.' : null,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              onChanged: isEditable ? onPhoneChanged : null,
              keyboardType: TextInputType.phone,
              enabled: isEditable,
            ),
          ],
        ),
      ),
    );
  }
}
