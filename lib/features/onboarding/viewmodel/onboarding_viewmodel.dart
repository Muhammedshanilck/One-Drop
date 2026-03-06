import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:one_drop/core/constants/app_text.dart';
import 'package:one_drop/core/routing/app_router.dart';
import 'package:one_drop/core/service/local_service_stoarge.dart';
import 'package:one_drop/core/theme/app_colors.dart';

class OnboardingViewModel
    extends
        ChangeNotifier {
  final GlobalKey<
    IntroductionScreenState
  >
  introKey =
      GlobalKey<
        IntroductionScreenState
      >();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  final LocalStorageService _storage = LocalStorageService();
  Future<
    void
  >
  completeOnboarding(
    BuildContext context,
  ) async {
    await _storage.setOnboardingCompleted();
    Navigator.pushReplacementNamed(
      context,
      AppRouter.login,
    );
  }

  List<
    PageViewModel
  >
  get pages => [
    PageViewModel(
      titleWidget: Text(
        AppText.onboardingTitle1,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        textAlign: TextAlign.center,
      ),

      bodyWidget: Text(
        AppText.onboardingBody1,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
      image: Image.asset(
        'assets/images/wc2.png',
        height: 230,
      ),
    ),
    PageViewModel(
      titleWidget: Text(
        AppText.onboardingTitle2,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        textAlign: TextAlign.center,
      ),

      bodyWidget: Text(
        AppText.onboardingBody2,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
      image: Image.asset(
        'assets/images/s3.png',
        height: 320,
      ),
    ),
    PageViewModel(
      titleWidget: Text(
        AppText.onboardingTitle3,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        textAlign: TextAlign.center,
      ),

      bodyWidget: Text(
        AppText.onboardingBody3,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
      image: Image.asset(
        'assets/images/n1.png',
        height: 250,
      ),
    ),
    PageViewModel(
      titleWidget: Text(
        AppText.onboardingTitle4,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        textAlign: TextAlign.center,
      ),

      bodyWidget: Text(
        AppText.onboardingBody4,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
      image: Image.asset(
        'assets/images/sh.png',
        height: 250,
      ),
    ),
  ];

  void onPageChanged(
    int index,
  ) {
    _currentIndex = index;
    notifyListeners();
  }

  void onSkip(
    BuildContext context,
  ) {
    Navigator.pushReplacementNamed(
      context,
      AppRouter.login,
    );
  }

  void onDone(
    BuildContext context,
  ) {
    Navigator.pushReplacementNamed(
      context,
      AppRouter.login,
    );
  }
}
