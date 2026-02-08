import 'package:flutter/material.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/features/auth/login/ui/screens/login_screen.dart';
import 'package:soliel/features/onboarding/screens/onboarding_screen.dart';
import 'package:soliel/features/onboarding/screens/select_role_screen.dart';
import 'package:soliel/features/splash/splash_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.onBoardingScreen:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case Routes.selectRoleScreen:
        return MaterialPageRoute(builder: (_) => const SelectRoleScreen());

      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
