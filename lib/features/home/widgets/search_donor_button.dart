import 'package:flutter/material.dart';
import 'package:one_drop/core/theme/app_colors.dart';

class SearchDonorButton extends StatelessWidget {
  const SearchDonorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.search),
        label: const Text(
          "Find Blood Donors",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}