import 'package:flutter/material.dart';
import 'package:soliel/core/di/dependency_injection.dart';
import 'package:soliel/core/routing/app_router.dart';
import 'package:soliel/soliel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupGetIt();

  runApp(Soliel(appRouter: AppRouter()));
}
