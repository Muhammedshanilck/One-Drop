import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:one_drop/core/constants/app_text.dart';
import 'package:provider/provider.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingView
    extends
        StatelessWidget {
  const OnboardingView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final vm = context
        .watch<
          OnboardingViewModel
        >();

    return IntroductionScreen(
      key: vm.introKey,
      pages: vm.pages,

      onChange: vm.onPageChanged,
      onSkip: () => vm.onSkip(
        context,
      ),
      onDone: () => vm.onDone(
        context,
      ),

      showSkipButton: true,
      controlsMargin: const EdgeInsets.only(
        bottom: 30,
      ),

      skip: const Text(
        AppText.skip,
        style: TextStyle(
          color: AppColors.textSecondary,
        ),
      ),

      next: const Text(
        AppText.next,
      ),

      done: const Text(
        AppText.getStarted,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),

      dotsDecorator: DotsDecorator(
        activeColor: AppColors.primary,
        size: const Size(
          10,
          10,
        ),
        activeSize: const Size(
          30,
          10,
        ),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
      ),
    );
  }
}
