import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/core/utils/extensions/navigation_extensions.dart';
import 'package:news_app/features/home/ui/cubit/home_cubit.dart';
import 'package:news_app/features/home/ui/views/home_screen.dart';
import 'package:news_app/features/home/ui/views/widgets/news_card.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_form_field.dart';


class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
        BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is BookMarkError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          } ,
          builder: (context, state) {
            final articles = context.read<HomeCubit>().bookmarkedArticles;

            if (state is BookMarkLoading && articles.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            if (articles.isEmpty) {
              return Center(child: Text("No bookmarks yet!"));
            }

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // GestureDetector(
                      //   onTap: () {
                      //     imageCache.clear();
                      //     imageCache.clearLiveImages();
                      //     debugPrint('Current route stack:');
                      //     Navigator.of(context).widget.pages.forEach((page) {
                      //       debugPrint(page.name ?? 'Unnamed route');
                      //     });
                      //     // Then use the correct navigation method
                      //     Navigator.pushReplacementNamed(context, Routes.homeScreen);
                      //     print("Back to Home Screen");
                      //   },
                      //   child: Icon(Icons.arrow_back, size: 28.sp),
                      // ),
                      // 16.horizontalSpace,
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Bookmarks',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomTextFormField(
                    hintText: "Search",
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: AppColor.black,
                    ),
                    suffixIcon: Icon(Icons.tune, color: AppColor.black),
                    onChanged: (value) {
                      context.read<HomeCubit>().searchBookmarks(value);
                      print(value);
                    },
                  ),
                ),
                16.verticalSpace,
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Dismissible(
                        key: Key(article.url ?? article.title ?? UniqueKey().toString()),                          direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          context.read<HomeCubit>().removeBookmark(article);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Bookmark removed') ,action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () => context.read<HomeCubit>().addBookmark(article),
                            ),),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 16.w),
                          child: Icon(Icons.delete, color: Colors.white, size: 28.sp),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Remove Bookmark'),
                              content: Text('Are you sure you want to remove this bookmark?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text('Remove'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              Routes.newsDetailsScreen,
                              arguments: {
                                'news': article,
                              },
                            );
                          },
                          child: NewsCard(news: article),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 16.h),
                  ),
                ),
              ],
            );
          },
        )
      ),
    );
  }

}