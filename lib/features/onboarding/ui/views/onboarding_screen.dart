
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/onboarding/ui/views/widgets/custom_body_onboarding.dart';
import 'package:news_app/features/onboarding/ui/views/widgets/custom_bottom_onboarding.dart';

import '../cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(flex: 2, child: CustomBodyOnboarding()),
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomBottomOnboarding(),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}