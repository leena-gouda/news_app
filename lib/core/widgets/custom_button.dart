import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final IconData? iconData;
  final Color? iconColor;
  final double? iconSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.height = 55,
    this.borderRadius = 4.0,
    this.textStyle,
    this.iconData,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColor.primaryColor,
        minimumSize: Size(double.infinity, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
      icon:Icon(  // Create Icon widget here
      iconData,
      color: iconColor,
      size: iconSize,
    ),
      label: Text(
        text,
        style: textStyle ??
        const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: AppColor.textGray,
        ),
      )
    );
  }
}