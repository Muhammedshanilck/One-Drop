import 'package:flutter/material.dart';
import 'package:one_drop/core/auth/auth_gate.dart';
import 'package:one_drop/features/main/view/main_view.dart';
import 'package:provider/provider.dart';
import 'package:one_drop/features/auth/view/login_view.dart';
import 'package:one_drop/features/auth/view/otp_view.dart';
import 'package:one_drop/features/auth/view/complete_profile_view.dart';
import 'package:one_drop/features/auth/viewmodel/otp_viewmodel.dart';
import 'package:one_drop/features/auth/repository/user_repository.dart';
import 'package:one_drop/features/home/view/home_view.dart';
import 'package:one_drop/features/onboarding/view/onboarding_view.dart';
import 'package:one_drop/features/splash/view/splash_view.dart';

class AppRouter {
  static const String splash = 'splash';
  static const String home = 'home';
  static const String login = 'login';
  static const String onboarding = 'onboarding';
  static const String otp = 'otp';
  static const String completeProfile = 'completeProfile';
  static const String authgate = '/';
  static const String a = 'completeProfile';
  static const String main = 'main';
  static Route<
    dynamic
  >
  generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const SplashView(),
        );

      case home:
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const HomeView(),
        );

      case login:
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const LoginView(),
        );

      case onboarding:
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const OnboardingView(),
        );

      case otp:
        final args =
            settings.arguments
                as Map<
                  String,
                  dynamic
                >;

        return MaterialPageRoute(
          builder:
              (
                _,
              ) => ChangeNotifierProvider(
                create:
                    (
                      _,
                    ) => OtpViewModel(
                      userRepository: UserRepository(),
                    ),
                child: OtpView(
                  phone: args["phone"],
                  verificationId: args["verificationId"],
                ),
              ),
        );

      case completeProfile:
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const CompleteProfileView(),
        );
      case authgate:
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const AuthGate(),
        );
      case main:
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const MainView(),
        );

      default:
        return MaterialPageRoute(
          builder:
              (
                _,
              ) => const Scaffold(
                body: Center(
                  child: Text(
                    'No route defined',
                  ),
                ),
              ),
        );
    }
  }
}
