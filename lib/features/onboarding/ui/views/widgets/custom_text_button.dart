import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Color? color;
  final bool? isBack;
  final void Function()? onPressed;

  const CustomTextButton({
    super.key,
    required this.text,
    this.color,
    this.onPressed, this.isBack,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: isBack == true ? null : AppColor.primaryColor,
        minimumSize: const Size(85, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color ?? Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}