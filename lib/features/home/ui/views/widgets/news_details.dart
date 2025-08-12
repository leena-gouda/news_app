import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/theme/app_colors.dart';
import 'package:news_app/features/home/ui/cubit/home_cubit.dart';

import '../../../data/models/news_model.dart';
import 'package:intl/intl.dart';

import '../../../data/repos/logo_api.dart';

class NewsDetailsScreen extends StatelessWidget {
  final NewsModel news;
  final String? category;

  const NewsDetailsScreen({super.key, required this.news, this.category});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // CircleAvatar(
                        //   backgroundImage:  news.urlToImage != null
                        //       ? NetworkImage(news.urlToImage!)
                        //       : const AssetImage("assets/images/default_publisher.png") as ImageProvider,
                        //   radius: 25.r,
                        // ),
                        Image.network(
                          LogoHelper.getLogoUrl(news.source?.name),
                          width: 20.w,
                          height: 20.h,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              LogoHelper.defaultLogo,
                              width: 20.w,
                              height: 20.h,
                              errorBuilder: (context, url, error) => Icon(Icons.broken_image, color: Colors.grey),
                            );
                          },
                          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                            if (frame == null) return CircularProgressIndicator();
                            return child;
                          },
                        ),

                        8.horizontalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(news.source?.name ?? 'Unknown Publisher',
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
                            category ?? "General",
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
                        errorBuilder: (context, url, error) => Icon(Icons.broken_image, color: Colors.grey,size: 50,),
                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                          if (frame == null) return CircularProgressIndicator();
                          return child;
                        },
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
                        // Text("Europe",
                        //     style: TextStyle(
                        //         color: AppColor.seeColor, fontSize: 14.sp, fontWeight: FontWeight.w400)),
                        // 4.verticalSpace,
                        Text(
                          news.title ?? '',
                          style: TextStyle(color: AppColor.black,
                            fontSize: 24, fontWeight: FontWeight.w600,),
                        ),
                        8.verticalSpace,
                        if (news.author != null)
                          Text(
                            "By ${news.author}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColor.seeColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        8.verticalSpace,
                        Text(
                          news.description ?? '',
                          style: TextStyle(fontSize: 16.sp, color: AppColor.seeColor,fontWeight: FontWeight.w400),
                        ),
                        12.verticalSpace,
                        if (news.content != null)
                          Text(
                            news.content!,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColor.black,
                            ),
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
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        final cubit = context.read<HomeCubit>();
                        final isSaved = cubit.isBookmarked(news);

                        return IconButton(
                          onPressed: () {
                            cubit.toggleBookmark(news);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(isSaved ? 'Removed from bookmarks' : 'Saved to bookmarks')),
                            );
                          },
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_outline,
                            color: Colors.blue,
                            size: 28,
                          ),
                        );


                      },
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}