import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/repos/onboarding_data.dart';
import '../../cubit/onboarding_cubit.dart';

class CustomBodyOnboarding extends StatelessWidget {
  const CustomBodyOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        return PageView.builder(
          controller: cubit.pageController,
          onPageChanged: (i) => cubit.chanePage(i),
          itemCount: onboardingPages.length,
          itemBuilder: (context, index) {
            final page = onboardingPages[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Image.asset(page.image,fit: BoxFit.cover,)),
                //SizedBox(height: 16),
                16.verticalSpace,
                Padding(
                  padding:  EdgeInsets.all(24.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        page.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          fontSize: 24.sp,
                        ),
                      ),
                      // SizedBox(height: 10),
                      10.verticalSpace,
                      Text(
                        page.supTitle,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}