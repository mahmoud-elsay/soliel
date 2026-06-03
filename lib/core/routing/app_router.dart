import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soliel/core/di/dependency_injection.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/features/auth/doctor_sign_up/logic/doctor_sign_up_cubit/doctor_sign_up_cubit.dart';
import 'package:soliel/features/auth/doctor_sign_up/ui/doctor_sign_up_screen.dart';
import 'package:soliel/features/auth/login/logic/login_cubit/login_cubit.dart';
import 'package:soliel/features/auth/login/ui/screens/login_screen.dart';
import 'package:soliel/features/auth/parent_sign_up/logic/parent_sign_up_cubit/parent_sign_up_cubit.dart';
import 'package:soliel/features/auth/parent_sign_up/ui/screens/parent_sign_up_screen.dart';
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
import 'package:soliel/features/settings/ui/screens/change_password_screen.dart';
import 'package:soliel/features/settings/ui/screens/notifications_Screen.dart';
import 'package:soliel/features/settings/ui/screens/privacy_screen.dart';
import 'package:soliel/features/settings/ui/screens/settings_screen.dart';
import 'package:soliel/features/splash/splash_screen.dart';
import 'package:soliel/features/test/data/models/eye_scan_response.dart';
import 'package:soliel/features/test/logic/eye_scan_cubit/eye_scan_cubit.dart';
import 'package:soliel/features/test/ui/screens/questionnaire_screen.dart';
import 'package:soliel/features/test/ui/screens/questions_screen.dart';
import 'package:soliel/features/test/ui/screens/scan_result_screen.dart';
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
        return MaterialPageRoute(
          builder: (_) => BlocProvider<LoginCubit>(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginScreen(),
          ),
        );

      case Routes.doctorSignUpScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<DoctorSignUpCubit>(
            create: (_) => getIt<DoctorSignUpCubit>(),
            child: const DoctorSignUpScreen(),
          ),
        );

      case Routes.parentSignUpScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<ParentSignUpCubit>(
            create: (_) => getIt<ParentSignUpCubit>(),
            child: const ParentSignUpScreen(),
          ),
        );

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
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<EyeScanCubit>(),
            child: const ScannerScreen(),
          ),
        );

      case Routes.scanResultScreen:
        final response = settings.arguments as EyeScanResponse;
        return MaterialPageRoute(
          builder: (_) => ScanResultScreen(response: response),
        );

      case Routes.startGameScreen:
        return MaterialPageRoute(builder: (_) => const StartGameScreen());

      case Routes.settingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case Routes.changePasswordScreen:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());

      case Routes.notificationsScreen:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case Routes.privacyScreen:
        return MaterialPageRoute(builder: (_) => const PrivacyScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
