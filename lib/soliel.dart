import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/routing/app_router.dart';
import 'package:soliel/core/theming/colors_manger.dart';

class Soliel extends StatelessWidget {
  final AppRouter appRouter;
  final String initialRoute;

  const Soliel({
    super.key,
    required this.appRouter,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Soliel',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: ColorsManager.white,
            primaryColor: ColorsManager.primaryGradientStart,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: ColorsManager.primaryGradientStart,
              selectionColor: ColorsManager.secondaryBlue,
              selectionHandleColor: ColorsManager.primaryGradientStart,
            ),
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: ColorsManager.primaryGradientStart,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: ColorsManager.white,
              iconTheme: IconThemeData(
                color: ColorsManager.primaryGradientStart,
              ),
              scrolledUnderElevation: 0,
            ),
          ),

          builder: (context, child) =>
              Directionality(textDirection: TextDirection.rtl, child: child!),

          initialRoute: initialRoute,

          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}
