import 'package:flutter/material.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/features/auth/doctor_sign_up/ui/doctor_sign_up_screen.dart';
import 'package:soliel/features/auth/login/ui/screens/login_screen.dart';
import 'package:soliel/features/auth/parent_sign_up/ui/parent_sign_up_screen.dart';
import 'package:soliel/features/auth/reset_password/ui/screens/reset_password_done_screen.dart';
import 'package:soliel/features/auth/reset_password/ui/screens/reset_password_screen.dart';
import 'package:soliel/features/doctor_profile/ui/screens/doctor_profile_screen.dart';
import 'package:soliel/features/doctor_profile/ui/screens/edit_profile_screen.dart';
import 'package:soliel/features/games/ui/screens/games_screen.dart';
import 'package:soliel/features/games/ui/screens/start_game_screen.dart';
import 'package:soliel/features/home/ui/screens/home_screen.dart';
import 'package:soliel/features/onboarding/screens/onboarding_screen.dart';
import 'package:soliel/features/onboarding/screens/select_role_screen.dart';
import 'package:soliel/features/parent_layout/parent_layout.dart';
import 'package:soliel/features/profile/ui/screens/profile_screen.dart';
import 'package:soliel/features/splash/splash_screen.dart';
import 'package:soliel/features/test/ui/screens/questionnaire_screen.dart';
import 'package:soliel/features/test/ui/screens/questions_screen.dart';
import 'package:soliel/features/test/ui/screens/scanner_screen.dart';
import 'package:soliel/features/test/ui/screens/test_screen.dart';

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

      case Routes.doctorSignUpScreen:
        return MaterialPageRoute(builder: (_) => const DoctorSignUpScreen());

      case Routes.parentSignUpScreen:
        return MaterialPageRoute(builder: (_) => const ParentSignUpScreen());

      case Routes.resetPasswordScreen:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());

      case Routes.resetPasswordDoneScreen:
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordDoneScreen(),
        );
      case Routes.doctorProfileScreen:
        return MaterialPageRoute(builder: (_) => const DoctorProfileScreen());

      case Routes.editProfileScreen:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case Routes.parentLayout:
        return MaterialPageRoute(builder: (_) => const ParentLayout());

      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case Routes.profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case Routes.gamesScreen:
        return MaterialPageRoute(builder: (_) => const GamesScreen());

      case Routes.testScreen:
        return MaterialPageRoute(builder: (_) => const TestScreen());

      case Routes.questionnaireScreen:
        return MaterialPageRoute(builder: (_) => const QuestionnaireScreen());

      case Routes.questionsScreen:
        final args = settings.arguments as QuestionsArgs;
        return MaterialPageRoute(builder: (_) => QuestionsScreen(args: args));

      case Routes.scannerScreen:
        return MaterialPageRoute(builder: (_) => const ScannerScreen());

      case Routes.startGameScreen:
        return MaterialPageRoute(builder: (_) => const StartGameScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
