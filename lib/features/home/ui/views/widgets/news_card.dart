import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/home/ui/views/widgets/news_clock_widget.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/news_model.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedNetworkImage(
              imageUrl: news.urlToImage ??
                  "https://img.freepik.com/free-photo/woman-beach-with-her-baby-enjoying-sunset_52683-144131.jpg?size=626&ext=jpg",

              width: 96.w,
              height: 96.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget:
              (context,url,error) => CachedNetworkImage(
                  imageUrl: "https://img.freepik.com/free-photo/woman-beach-with-her-baby-enjoying-sunset_52683-144131.jpg?size=626&ext=jpg",
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          8.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (news.source?.name != null)
                  Text(
                    news.source!.name!,
                    style: TextStyle(
                      color: AppColor.seeColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                // Text(
                //   "Europe",
                //   style: TextStyle(
                //     color: AppColor.seeColor,
                //     fontSize: 14.sp,
                //     fontWeight:  FontWeight.w500,
                //   )
                // ),
                Text(
                  news.title ?? "No title",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:  Theme.of(
                  context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
                ),
                const SizedBox(height: 8),
                NewsClockWidget(
                  sourceName: news.source?.name,
                  publishedAt: news.publishedAt,
                ),
              ]
            ),
          )
        ],
      ),
    );
  }
}