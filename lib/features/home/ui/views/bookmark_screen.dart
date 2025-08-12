import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/home/ui/cubit/home_cubit.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_form_field.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      size: 28.sp,
                    ),
                  ),
                  16.horizontalSpace,
                  Text(
                    'Bookmarks',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final controller = context.read<HomeCubit>();
                  final articles = controller.bookmarkedArticles.toList();
                  final searchField = CustomTextFormField(
                    hintText: "Search",
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: AppColor.black,
                    ),
                    suffixIcon: Icon(Icons.tune, color: AppColor.black),
                    onChanged: (value) {
                      print(value);
                    },
                  );

                  if (state is HomeLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is HomeError) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                  if (articles.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Text('No bookmarks yet!', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ),
                    );
                  }
                  if(state is HomeSuccess){
                    return Expanded(
                      child: ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          return ListTile(
                            title: Text(article.title ?? 'No Title'),
                            subtitle: Text(article.description ?? 'No Description'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                controller.removeBookmark(article);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
