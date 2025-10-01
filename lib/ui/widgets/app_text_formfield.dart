import 'package:flutter/material.dart';
import '../../core/color_constants.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final Color fillColor;
  final bool readOnly;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? suffixIcon;

  const AppTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.isPassword = false,
    this.fillColor = ColorConstants.lightGray,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isPassword ? obscure : false,
      style: const TextStyle(color: ColorConstants.black),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        hintStyle: TextStyle(
          color: ColorConstants.black.withValues(alpha: 0.4),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.shadowGray),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.shadowGray),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.shadowGray),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.all(12),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
