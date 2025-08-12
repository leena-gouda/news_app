import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/home/data/repos/logo_api.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsClockWidget extends StatelessWidget {
  final String? sourceName;
  final String? publishedAt;

  const NewsClockWidget({super.key, this.sourceName, this.publishedAt});

  String formatDate(String? isoDate) {
    if (isoDate == null) return "";
    final date = DateTime.tryParse(isoDate);
    return date != null ? timeago.format(date) : "";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(
          LogoHelper.getLogoUrl(sourceName),
          width: 20.w,
          height: 20.h,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              LogoHelper.defaultLogo,
              width: 20.w,
              height: 20.h,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image_not_supported, size: 20.w);
              },
            );
          }
        ),
        4.horizontalSpace,
        Flexible(child: Text(sourceName ?? "UnKnown")),
        12.horizontalSpace,
        Icon(CupertinoIcons.clock, size: 14),
        4.horizontalSpace,
        Text(
          formatDate(publishedAt),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColor.seeColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Spacer(),
        // Icon(Icons.more_horiz_outlined, size: 14),
      ],
    );
  }
}