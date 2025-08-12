import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/core/utils/extensions/navigation_extensions.dart';
import 'package:news_app/features/home/ui/views/notification_page.dart';
import 'package:news_app/features/home/ui/views/widgets/custom_row_title.dart';
import 'package:news_app/features/home/ui/views/widgets/news_card.dart';
import 'package:news_app/features/home/ui/views/widgets/news_clock_widget.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../data/models/news_model.dart';
import '../../data/repos/news_api_repo.dart';
import '../cubit/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
      HomeCubit(NewsApiRepo())
        ..getDate()
        ..getNews()
        ..requestPermission(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeSignOut) {
                context.pushNamedAndRemoveUntil(Routes.splashScreen);
              }
              if (state is HomeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  children: [
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        final controller = context.read<HomeCubit>();
                        return Column(
                          children: [
                            Row(
                              children: [
                                if (controller.showCategoryView)
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_back,color: AppColor.primaryColor),
                                          onPressed: () {
                                            controller.disableCategoryView();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                Image.asset(
                                  AppAssets.logoApp,
                                  height: 30.h,
                                  width: 120.w,
                                  fit: BoxFit.cover,
                                ),
                                Spacer(),
                                Container(
                                  width: 35.w,
                                  height: 35.h,

                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(6.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(
                                          0,
                                          3,
                                        ), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    child: Icon(
                                      Icons.notifications,
                                      color: AppColor.black,
                                    ),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsPage()));
                                    },
                                  ),
                                ),
                              ],
                            ),
                            30.verticalSpace,
                            if(!controller.showCategoryView)
                              CustomTextFormField(
                                hintText: "Search",
                                prefixIcon: Icon(
                                  CupertinoIcons.search,
                                  color: AppColor.black,
                                ),
                                suffixIcon: Icon(Icons.tune, color: AppColor.black),
                                onChanged: (value) {
                                  controller.getNews(value.isEmpty ? null : value);
                                  print(value);
                                },
                              ),
                            16.verticalSpace,
                          ],
                        );
                      },
                    ),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        final controller = context.read<HomeCubit>();
                        if (state is HomeLoading) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  backgroundColor: Colors.yellow,
                                  color: AppColor.primaryColor,
                                  strokeWidth: 5,
                                  semanticsLabel: 'Loading',
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Loading...',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (state is HomeError) {
                          return Center(child: Text('Error: ${state.message}'));
                        }
                        if (state is HomeSuccess) {
                          final trendingArticle = state.news.first;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(!controller.showCategoryView)...[
                                CustomRowTitle(title: "Trending",onPressed: (){Navigator.pushNamed(context, Routes.trendingScreen);} ,),
                                16.verticalSpace,
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.newsDetailsScreen,
                                      arguments: {
                                        'news': trendingArticle,
                                      },
                                    );
                                  },
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          width: 365.w,
                                          height: 185.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: Offset(
                                                  0,
                                                  3.h,
                                                ), // changes position of shadow
                                              ),
                                            ],
                                          ),

                                          child: CachedNetworkImage(
                                            imageUrl: trendingArticle.urlToImage ?? '',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        12.verticalSpace,
                                        Text(
                                          trendingArticle.source?.name ?? "Unknown",
                                          style: TextStyle(color: AppColor.seeColor, fontSize: 14.sp),
                                        ),
                                        4.verticalSpace,
                                        Text(
                                          trendingArticle.title ?? "",
                                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                                        ),
                                        4.verticalSpace,
                                        NewsClockWidget(),
                                        24.verticalSpace,
                                      ]
                                  ),
                                )
                              ],
                              GestureDetector(
                                onTap: () {
                                  controller.enableCategoryView(
                                    controller.selectedCategory,
                                    controller.currentIndex,
                                  );
                                },
                                child: Column(
                                  children: [
                                    CustomRowTitle(title: "Latest",onPressed: () {
                                      controller.enableCategoryView( controller.selectedCategory, controller.currentIndex,);
                                    },),
                                    16.verticalSpace,
                                    SizedBox(
                                      height: 40,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (context, index) => GestureDetector(
                                          onTap: () {
                                            controller.getNewsByCategory(
                                              controller.categories[index],
                                              index,
                                            );
                                          },
                                          child: IntrinsicWidth(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  controller.categories[index][0].toUpperCase() + controller.categories[index].substring(1),
                                                  style: TextStyle(
                                                    color: AppColor.black,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                    FontWeight.bold,

                                                  ),
                                                ),
                                                4.verticalSpace,
                                                Container(
                                                  height: 2.5.h,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    controller.currentIndex ==
                                                        index
                                                        ? AppColor
                                                        .primaryColor
                                                        : Colors
                                                        .transparent,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                      12.r,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        separatorBuilder:
                                            (context, index) =>
                                            SizedBox(width: 12.w),
                                        itemCount: controller.categories.length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.separated(
                                itemCount: state.news.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (context, index) => GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                      Routes.newsDetailsScreen,
                                      arguments: {
                                        'news': state.news[index],
                                        'category': controller.selectedCategory,
                                      },
                                    );
                                  },
                                  child: NewsCard(news: state.news[index]),
                                ),
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 16.h,
                                ),
                              ),
                            ],
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}