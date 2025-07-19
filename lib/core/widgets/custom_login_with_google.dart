import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_colors.dart';

class CustomLoginWithGoogle extends StatelessWidget {
  final String imagePath;
  final void Function()? onTap;

  const CustomLoginWithGoogle({super.key, required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 27,
        backgroundColor: AppColor.primaryColor,
        child: CircleAvatar(
          radius: 25,
          backgroundColor: AppColor.secondaryColor,
          child: SvgPicture.asset(imagePath, width: 26, height: 26),
        ),
      ),
    );
  }
}