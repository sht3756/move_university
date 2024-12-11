import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  IconData? prefixIcon,
  String? hintText,
  String? errorText,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType,
  void Function(String)? onChanged,
  bool enabled = true,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      labelText: label,
      hintText: hintText,
      errorText: errorText,
    ),
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    onChanged: onChanged,
    enabled: enabled,
  );
}