import 'package:flutter/material.dart';

class CustomTextAuth extends StatelessWidget {
  final String text;
  const CustomTextAuth({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold,),
    );
  }
}