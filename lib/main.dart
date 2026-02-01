import 'package:flutter/material.dart';

import 'package:soliel/core/routing/app_router.dart';
import 'package:soliel/soliel.dart';

void main() {
  ///using get_it / dependency injection in future:
  // setupGetIt();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Soliel(appRouter: AppRouter()));
}
