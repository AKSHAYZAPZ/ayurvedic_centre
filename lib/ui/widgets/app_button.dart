import 'package:ayurvedic_centre/core/color_constants.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;
  final void Function()? onTap;
  final bool? isLoading;
  final Color? color;
  const AppButton({
    super.key,
    required this.text,
    this.height,
    this.onTap,
    this.width,
    this.isLoading,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double baseHeight = height ?? 38;
    final double baseWidth = width ?? MediaQuery.of(context).size.width;

    return SizedBox(
      height: baseHeight,
      width: baseWidth,
      child: GestureDetector(
        onTap: (isLoading ?? false) ? null : onTap,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: baseHeight,
            width: (isLoading ?? false) ? baseHeight : baseWidth,
            decoration: BoxDecoration(
              color: color ?? ColorConstants.green,
              borderRadius: BorderRadius.circular(
                (isLoading ?? false) ? baseHeight / 2 : 8,
              ),
            ),
            child: Center(
              child: (isLoading ?? false)
                  ? CircularProgressIndicator(
                      color: ColorConstants.white,
                      strokeWidth: 2,
                    )
                  : Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: ColorConstants.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
