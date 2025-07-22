import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';

class NewsClockWidget extends StatelessWidget {
  const NewsClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          AppAssets.bbcIcon,
          width: 20.w,
          height: 20.h,
        ),
        4.horizontalSpace,
        Text("BBC News"),
        12.horizontalSpace,
        Icon(CupertinoIcons.clock, size: 14),
        4.horizontalSpace,
        Text(
          "4h ago",
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColor.seeColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        Icon(Icons.more_horiz_outlined, size: 14),
      ],
    );
  }
}