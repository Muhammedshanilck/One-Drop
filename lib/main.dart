import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:one_drop/core/routing/app_router.dart';
import 'package:one_drop/core/theme/app_theme.dart';
import 'package:one_drop/core/theme/theme_provider.dart';
import 'package:one_drop/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:one_drop/features/onboarding/viewmodel/onboarding_viewmodel.dart';
import 'package:one_drop/firebase_options.dart';
import 'package:provider/provider.dart';

Future<
  void
>
main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const OneDrop(),
  );
}

class OneDrop
    extends
        StatelessWidget {
  const OneDrop({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MultiProvider(
      providers: [
        /// AUTH
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => AuthViewModel(),
        ),

        /// THEME PROVIDER
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => ThemeProvider(),
        ),

        /// ONBOARDING
        ChangeNotifierProvider(
          create:
              (
                _,
              ) => OnboardingViewModel(),
        ),
      ],

      /// CONSUMER FOR THEME SWITCHING
      child:
          Consumer<
            ThemeProvider
          >(
            builder:
                (
                  context,
                  themeProvider,
                  child,
                ) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'One Drop',

                    /// LIGHT THEME
                    theme: AppTheme.lightTheme,

                    /// DARK THEME
                    darkTheme: AppTheme.darkTheme,

                    /// ACTIVE THEME
                    themeMode: themeProvider.themeMode,

                    onGenerateRoute: AppRouter.generateRoute,
                    initialRoute: AppRouter.authgate,
                  );
                },
          ),
    );
  }
}
