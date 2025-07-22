import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomRowTitle extends StatelessWidget {
  final String title;
  const CustomRowTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child:  Text(
            'See All',
            style: TextStyle(
              color: AppColor.seeColor,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}