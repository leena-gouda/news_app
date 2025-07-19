
import 'package:flutter/material.dart';
import 'package:news_app/core/routing/routes.dart';

import '../../features/auth/login/ui/screens/login_screen.dart';

import '../../features/auth/signup/ui/screens/sign_up_screen.dart';
import '../../features/home/data/models/news_model.dart';
import '../../features/home/ui/views/home_screen.dart';
import '../../features/home/ui/views/widgets/news_destils.dart';
import '../../features/onboarding/ui/views/onboarding_screen.dart';
import '../../features/splash_screen/ui/views/splash_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.splashScreen:
        return _createRoute(SplashScreen());
      case Routes.onboardingScreen:
        return _createRoute(OnboardingScreen());
      case Routes.homeScreen:

        return _createRoute(HomeScreen());
      case Routes.loginScreen:
        return _createRoute(LoginScreen());
      case Routes.signupsScreen:
        return _createRoute(SignUpScreen());
      case Routes.newsDetailsScreen:
        final news = arguments as NewsModel;
        return _createRoute(NewsDetailsScreen(news: news));

      default:
        return MaterialPageRoute(
          settings: settings,
          builder:
              (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}