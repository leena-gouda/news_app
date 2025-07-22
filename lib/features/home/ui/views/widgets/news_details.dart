import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/theme/app_colors.dart';

import '../../../data/models/news_model.dart';
import 'package:intl/intl.dart';

class NewsDetailsScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailsScreen({super.key, required this.news});

  String formatDate(String? isoDate) {
    if (isoDate == null) return "";
    final date = DateTime.tryParse(isoDate);
    return date != null ? "${DateFormat('jm').format(date)} ago" : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(25.r),
              child: Row(
                children: [
                  GestureDetector(
                    child: Icon(Icons.arrow_back,size:28.r,),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  GestureDetector(
                    child: Icon(Icons.share_outlined,size:28.r,),
                    onTap: (){},
                  ),
                  8.horizontalSpace,
                  GestureDetector(
                    child: Icon(Icons.more_vert_outlined,size: 28.r,),
                    onTap: (){},
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.r),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage("assets/images/bbc.png"), // أو NetworkImage إذا متوفرة
                          radius: 25.r,
                        ),
                        8.horizontalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(news.source?.name ?? '',
                                style: TextStyle(color: AppColor.black,
                                    fontWeight: FontWeight.w600, fontSize: 16.sp)),
                            Text(
                              formatDate(news.publishedAt),
                              style: TextStyle(color: AppColor.seeColor, fontSize: 14,fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.fromLTRB(12.w,5.h,11.w,5.h),
                          width: 102.w,
                          height: 34.h,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child:  Text(
                            "Following",
                            style: TextStyle(color: Colors.white, fontSize: 16.sp,fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    16.verticalSpace,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.r),
                      child: news.urlToImage != null
                          ? Image.network(
                        news.urlToImage!,
                        width: 380.w,
                        height: 248.h,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        height: 248.h,
                        width: 380.w,
                        color: AppColor.textGray,
                        child: Icon(Icons.image, size: 50.r),
                      ),
                    ),
                    20.verticalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Europe",
                            style: TextStyle(
                                color: AppColor.seeColor, fontSize: 14.sp, fontWeight: FontWeight.w400)),
                        4.verticalSpace,
                        Text(
                          news.title ?? '',
                          style: TextStyle(color: AppColor.black,
                            fontSize: 24, fontWeight: FontWeight.w600,),
                        ),
                        8.verticalSpace,
                        Text(
                          news.description ?? '',
                          style: TextStyle(fontSize: 16.sp, color: AppColor.seeColor,fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 34.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.pink, size: 24.r),
                    3.horizontalSpace,
                    Text("24.5K",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400)),
                    20.horizontalSpace,
                    Icon(Icons.chat_bubble_outline, size: 24.r),
                    4.horizontalSpace,
                    Text("1K",
                        style: TextStyle(fontSize: 15.sp)),
                    const Spacer(),
                    Icon(Icons.bookmark_outlined,
                        size: 24.r,
                        color: AppColor.primaryColor),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}