
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/extensions/navigation_extensions.dart';
import 'package:news_app/features/home/ui/views/widgets/news_card.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
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
        floatingActionButton: null,
        appBar: AppBar(
          title: Text(
            'News App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout, color: AppColor.primaryColor),
              onPressed: () {
                context.read<HomeCubit>().signOut();
              },
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocListener<HomeCubit, HomeState>(
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
          child: Column(
            children: [
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final controller = context.read<HomeCubit>();
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        CustomTextFormField(
                          hintText: "Search for news",
                          prefixIcon: Icon(Icons.search),
                          onChanged: (value) {
                            controller.getNews(value.isEmpty ? null : value);
                            print(value);
                          },
                        ),
                        SizedBox(height: 10),
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
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  controller.categories[index],
                                  style: TextStyle(
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            separatorBuilder:
                                (context, index) => SizedBox(height: 10),
                            itemCount: controller.categories.length,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
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
                      return ListView.builder(
                        itemCount: state.news.length,
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
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: 'Bookmark',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              label: 'Profile',
            ),
          ],
          currentIndex: 0, // You'll need to manage this state
          onTap: (index) {
            // Handle navigation
          },
          unselectedItemColor: AppColor.textGray,
          selectedItemColor: AppColor.primaryColor,
          backgroundColor: AppColor.white,
        ),
        // bottomNavigationBar: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     CustomButton(
        //       text: "Home",
        //       onPressed: (){},
        //       iconData: Icons.home_filled,
        //     ),
        //     CustomButton(
        //       text: "Explore",
        //       onPressed: (){},
        //       iconData: Icons.explore
        //     ),
        //     CustomButton(
        //       text: "Bookmark",
        //       onPressed: (){},
        //       iconData: Icons.bookmark_border,
        //     ),
        //     CustomButton(
        //       text: "Profile",
        //       onPressed: (){},
        //       iconData: Icons.person_outlined,
        //     ),
        //   ],
        // ),
      ),
    );
  }
}