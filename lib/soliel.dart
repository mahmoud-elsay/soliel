import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:soliel/core/routing/app_router.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';

class Soliel extends StatelessWidget {
  final AppRouter appRouter;

  const Soliel({super.key, required this.appRouter});

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

          // Arabic support + RTL
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ar')],

          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },

          initialRoute: Routes.homeScreen,

          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}
