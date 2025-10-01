import 'package:flutter/material.dart';

import '../../core/color_constants.dart';

class AppDropdownField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String hintText;
  final bool isExpanded;
  final Color fillColor;

  const AppDropdownField({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.hintText = '',
    this.isExpanded = true,
    this.fillColor = ColorConstants.lightGray,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      isExpanded: isExpanded,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        hintStyle:
            TextStyle(color: ColorConstants.black.withValues(alpha: 0.4)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.shadowGray),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.white),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.shadowGray),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
