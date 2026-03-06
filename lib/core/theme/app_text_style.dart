import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const subHeading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}