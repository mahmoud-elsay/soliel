import 'package:flutter/material.dart';
import 'package:soliel/core/di/dependency_injection.dart';
import 'package:soliel/core/helpers/app_role.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/core/routing/app_router.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/soliel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();

  final initialRoute = await _getInitialRoute();

  runApp(Soliel(appRouter: AppRouter(), initialRoute: initialRoute));
}

Future<String> _getInitialRoute() async {
  final accessToken = await StorageHelper.getAccessToken();

  if (accessToken == null || accessToken.isEmpty) {
    return Routes.loginScreen;
  }

  final role = await AppRoleFactory.getCurrentRole();
  return role?.initialRouteAfterLogin ?? Routes.homeScreen;
}
