import 'package:flutter/material.dart';
import 'package:one_drop/core/theme/app_colors.dart';

class AppButton
    extends
        StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                text,
              ),
      ),
    );
  }
}
