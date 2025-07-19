import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final InputBorder? border;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.border,
    this.textStyle,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      style: textStyle ??
          const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
      decoration: InputDecoration(
        fillColor: const Color(0xFFF3F3F3),
        filled: true,
        hintText: hintText,
        hintStyle: hintStyle ??
            const TextStyle(
              fontSize: 12,
              color: Color(0xFF676767),
              fontWeight: FontWeight.w500,
            ),
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
            ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red),
        ),

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}