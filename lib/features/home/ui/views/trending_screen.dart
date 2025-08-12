import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/home/ui/views/widgets/news_clock_widget.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/news_model.dart';
import '../cubit/home_cubit.dart';

class TrendingScreen extends StatelessWidget {
  const TrendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger Cubit after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getTrendingNews();
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Trending News")),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final controller = context.read<HomeCubit>();
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeSuccess) {
            final trendingNews = state.news;
            return ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: trendingNews.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final article = trendingNews[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.newsDetailsScreen,
                        arguments: {
                          'news': article,
                        },
                      );
                    },
                    child: buildNewsCard(article),
                  );
                }
            );
          } else if (state is HomeError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildNewsCard(NewsModel article) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: CachedNetworkImage(
              imageUrl: article.urlToImage ?? '',
              height: 180.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.broken_image, color: Colors.grey),

            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.source?.name ?? "Unknown",
                  style: TextStyle(color: AppColor.seeColor, fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 6.h),
                Text(
                  article.title ?? "",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6.h),
                NewsClockWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
