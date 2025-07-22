import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/onboarding_cubit.dart';
import 'custom_text_button.dart';

class CustomHeaderOnboarding extends StatelessWidget {
  const CustomHeaderOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
                text: "${state + 1}",
                children: [
                  TextSpan(
                    text: "/3",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            CustomTextButton(
              text: "Skip",
              onPressed: () {
                context.read<OnboardingCubit>().skip();
              },
            ),
          ],
        );
      },
    );
  }
}