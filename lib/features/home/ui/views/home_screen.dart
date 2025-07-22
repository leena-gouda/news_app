
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:news_app/core/utils/extensions/navigation_extensions.dart';
// import 'package:news_app/features/home/ui/views/widgets/custom_row_title.dart';
// import 'package:news_app/features/home/ui/views/widgets/news_card.dart';
// import 'package:news_app/features/home/ui/views/widgets/news_clock_widget.dart';
//
// import '../../../../core/constants/app_assets.dart';
// import '../../../../core/routing/routes.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/widgets/custom_button.dart';
// import '../../../../core/widgets/custom_text_form_field.dart';
// import '../../data/repos/news_api_repo.dart';
// import '../cubit/home_cubit.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create:
//           (context) =>
//       HomeCubit(NewsApiRepo())
//         ..getDate()
//         ..getNews()
//         ..requestPermission(),
//       child: Scaffold(
//         // appBar: AppBar(
//         //   title: Text(
//         //     'News App',
//         //     style: TextStyle(
//         //       fontWeight: FontWeight.bold,
//         //       color: AppColor.primaryColor,
//         //     ),
//         //   ),
//         //   actions: [
//         //     IconButton(
//         //       icon: Icon(Icons.logout, color: AppColor.primaryColor),
//         //       onPressed: () {
//         //         context.read<HomeCubit>().signOut();
//         //       },
//         //     ),
//         //   ],
//         //   automaticallyImplyLeading: false,
//         //   backgroundColor: Colors.white,
//         //   elevation: 0,
//         // ),
//         body: SafeArea(
//           bottom: false,
//           child: BlocListener<HomeCubit, HomeState>(
//             listener: (context, state) {
//               if (state is HomeSignOut) {
//                 context.pushNamedAndRemoveUntil(Routes.splashScreen);
//               }
//               if (state is HomeError) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Error: ${state.message}')),
//                 );
//               }
//             },
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: Padding(
//                 padding: EdgeInsets.all(24.r),
//                 child: Column(
//                   children: [
//                     BlocBuilder<HomeCubit, HomeState>(
//                       builder: (context, state) {
//                         final controller = context.read<HomeCubit>();
//                         return Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Image.asset(
//                                   AppAssets.logoApp,
//                                   height: 30.h,
//                                   ),
//                                 Spacer(),
//                                 Container(
//                                   width: 35.w,
//                                   height: 35.h,
//                                   decoration: BoxDecoration(
//                                       color: AppColor.white,
//                                       borderRadius: BorderRadius.circular(6.r),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withOpacity(0.1),
//                                           spreadRadius: 1,
//                                           blurRadius: 5,
//                                           offset: Offset(0, 3),
//                                         )
//                                       ]
//                                   ),
//                                   child: GestureDetector(
//                                     child: Icon(Icons.notifications,color: AppColor.black,),
//                                     onTap: (){},
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             40.verticalSpace,
//                             CustomTextFormField(
//                               hintText: "Search",
//                               prefixIcon: Icon(CupertinoIcons.search,color: AppColor.black,),
//                               suffixIcon: Icon(Icons.tune,color: AppColor.black),
//                               onChanged: (value) {
//                                 controller.getNews(value.isEmpty ? null : value);
//                                 print(value);
//                               },
//                             ),
//                            // SizedBox(height: 10),
//                             16.verticalSpace,
//                           ],
//                         );
//                       },
//                     ),
//
//                     BlocBuilder<HomeCubit, HomeState>(
//                       builder: (context, state) {
//                         final Controller = context.read<HomeCubit>();
//                         if (state is HomeLoading) {
//                           return Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 CircularProgressIndicator(
//                                   backgroundColor: Colors.yellow,
//                                   color: AppColor.primaryColor,
//                                   strokeWidth: 5.w,
//                                   semanticsLabel: 'Loading',
//                                 ),
//                                 //SizedBox(height: 20),
//                                 20.verticalSpace,
//                                 Text(
//                                   'Loading...',
//                                   style: TextStyle(
//                                     fontSize: 20.sp,
//                                     fontWeight: FontWeight.bold,
//                                     color: AppColor.primaryColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }
//                         if (state is HomeError) {
//                           return Center(child: Text('Error: ${state.message}'));
//                         }
//                         if (state is HomeSuccess) {
//                           return Column(
//                             children: [
//                               CustomRowTitle(title: "Trending"),
//                               16.verticalSpace,
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     clipBehavior: Clip.antiAliasWithSaveLayer,
//                                     width: 365.w,
//                                     height: 185.h,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8.r),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withOpacity(0.5),
//                                           spreadRadius: 1,
//                                           blurRadius: 5,
//                                           offset: Offset(0, 3.h)
//                                         )
//                                       ]
//                                     ),
//                                     child: CachedNetworkImage(
//                                       imageUrl: "https://www.navalnews.com/wp-content/uploads/2020/04/Russian_cruiser_Moskva.jpg",
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   12.verticalSpace,
//                                   Text(
//                                     "Europe",
//                                     style: TextStyle(
//                                       color: AppColor.seeColor,
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   4.verticalSpace,
//                                   Text(
//                                     "Russian warship : Moskva sinks in Black sea",
//                                     style: TextStyle(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   4.verticalSpace,
//                                   NewsClockWidget(),
//                                   24.verticalSpace,
//                                   CustomRowTitle(title: "Latest"),
//                                   16.verticalSpace,
//                                   SizedBox(
//                                     height: 40.h,
//                                     child:  ListView.separated(
//                                       scrollDirection: Axis.horizontal,
//                                       shrinkWrap: true,
//                                       itemBuilder:
//                                           (context, index) => GestureDetector(
//                                         onTap: () {
//                                           Controller.getNewsByCategory(
//                                             Controller.categories[index],
//                                             index
//                                           );
//                                         },
//                                         child: IntrinsicWidth(
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                             children: [
//                                               Text(
//                                                 Controller.categories[index][0].toUpperCase()+Controller.categories[index].substring(1),
//                                                 style: TextStyle(
//                                                   color: AppColor.black,
//                                                   fontSize: 14.sp,
//                                                   fontWeight: FontWeight.bold
//                                                 )
//                                               ),
//                                               4.verticalSpace,
//                                               Container(
//                                                 height: 2.5.h,
//                                                 decoration: BoxDecoration(
//                                                   color: Controller.currentIndex == index ? AppColor.primaryColor : Colors.transparent,
//                                                   borderRadius: BorderRadius.circular(12.r),
//                                                 ),
//                                               )
//                                             ]
//                                           ),
//                                         ),
//                                       ),
//                                       separatorBuilder:
//                                           (context, index) => SizedBox(height: 12.h),
//                                       itemCount: Controller.categories.length,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               ListView.separated(
//                                 itemCount: state.news.length,
//                                 shrinkWrap: true,
//                                 physics: NeverScrollableScrollPhysics(),
//                                 itemBuilder:
//                                     (context, index) => GestureDetector(
//                                   onTap: () {
//                                     context.pushNamed(
//                                       Routes.newsDetailsScreen,
//                                       arguments: state.news[index],
//                                     );
//                                   },
//                                   child: NewsCard(news: state.news[index]),
//                                 ),
//                                 separatorBuilder: (BuildContext context,index) => SizedBox(height: 16.h) ,
//                               ),
//                             ],
//                           );
//                         }
//                         return SizedBox();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home_filled),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.explore),
//               label: 'Explore',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.bookmark_border),
//               label: 'Bookmark',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person_outlined),
//               label: 'Profile',
//             ),
//           ],
//           currentIndex: 0, // You'll need to manage this state
//           onTap: (index) {
//             // Handle navigation
//           },
//           unselectedItemColor: AppColor.textGray,
//           selectedItemColor: AppColor.primaryColor,
//           backgroundColor: AppColor.white,
//         ),
//         // bottomNavigationBar: Row(
//         //   mainAxisAlignment: MainAxisAlignment.center,
//         //   crossAxisAlignment: CrossAxisAlignment.center,
//         //   children: [
//         //     CustomButton(
//         //       text: "Home",
//         //       onPressed: (){},
//         //       iconData: Icons.home_filled,
//         //     ),
//         //     CustomButton(
//         //       text: "Explore",
//         //       onPressed: (){},
//         //       iconData: Icons.explore
//         //     ),
//         //     CustomButton(
//         //       text: "Bookmark",
//         //       onPressed: (){},
//         //       iconData: Icons.bookmark_border,
//         //     ),
//         //     CustomButton(
//         //       text: "Profile",
//         //       onPressed: (){},
//         //       iconData: Icons.person_outlined,
//         //     ),
//         //   ],
//         // ),
//       ),
//     );
//   }
// }




import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/core/utils/extensions/navigation_extensions.dart';
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
                                      // context.read<HomeCubit>().signOut();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            40.verticalSpace,
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

                            //
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
                          return Column(
                            children: [
                              CustomRowTitle(title: "Trending"),
                              16.verticalSpace,
                              Column(
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
                                      imageUrl:
                                      "https://www.navalnews.com/wp-content/uploads/2020/04/Russian_cruiser_Moskva.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  12.verticalSpace,
                                  Text(
                                    "Europe",
                                    style: TextStyle(
                                      color: AppColor.seeColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    "Russian warship: Moskva sinks in Black Sea",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  4.verticalSpace,
                                  NewsClockWidget(),
                                  24.verticalSpace,
                                  CustomRowTitle(title: "Latest"),
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
                              ListView.separated(
                                itemCount: state.news.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder:
                                    (context, index) => GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                      Routes.newsDetailsScreen,
                                      arguments: state.news[index],
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