
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/extensions/navigation_extensions.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../data/repos/onboarding_data.dart';
import '../../cubit/onboarding_cubit.dart';
import 'custom_text_button.dart';

class CustomBottomOnboarding extends StatelessWidget {
  const CustomBottomOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, state) {
        final controller = context.read<OnboardingCubit>();
        final isLastPage = state == (onboardingPages.length - 1);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                ...List.generate(
                  onboardingPages.length,
                      (index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 14,
                    height: 14,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color:
                      index == state ? AppColor.primaryColor : AppColor.textGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Visibility(
                  visible: state != 0,
                  child: CustomTextButton(
                    isBack: true,
                    text: 'Back',
                    color: AppColor.black,
                    onPressed: () {
                      controller.previousPage();
                    },
                  ),
                ),
                CustomTextButton(
                  text:
                  state == (onboardingPages.length - 1)
                      ? 'Get Started'
                      : 'Next',
                  color: AppColor.white,
                  onPressed: () {
                    if (isLastPage) {
                      context.pushNamedAndRemoveUntil(Routes.loginScreen);
                    } else {
                      controller.nextPage();
                    }
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}