import 'package:flutter/material.dart';
import 'package:one_drop/core/theme/app_colors.dart';
import '../../auth/model/user_model.dart';

class DonorStatusCard
    extends
        StatelessWidget {
  final UserModel? user;
  final Function(
    bool,
  )
  onToggle;

  const DonorStatusCard({
    super.key,
    required this.user,
    required this.onToggle,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(
      context,
    );

    /// If user has not registered as donor
    if (user?.bloodGroup ==
        null) {
      return SizedBox(
        width: double.infinity,
        height: 55,
        child: OutlinedButton.icon(
          icon: const Icon(
            Icons.volunteer_activism,
          ),
          label: const Text(
            "Become a Donor",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(
              color: AppColors.primary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
          ),
        ),
      );
    }

    final bool isAvailable =
        user?.isAvailable ==
        true;

    return Container(
      padding: const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor, // dark mode safe
        borderRadius: BorderRadius.circular(
          14,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              .05,
            ),
            blurRadius: 6,
            offset: const Offset(
              0,
              3,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Status Icon
          Container(
            padding: const EdgeInsets.all(
              10,
            ),
            decoration: BoxDecoration(
              color: isAvailable
                  ? Colors.green.withOpacity(
                      .15,
                    )
                  : Colors.red.withOpacity(
                      .15,
                    ),
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Icon(
              Icons.bloodtype,
              color: isAvailable
                  ? Colors.green
                  : Colors.red,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          /// Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Donor Status",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  isAvailable
                      ? "Available for donation"
                      : "Currently unavailable",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isAvailable
                        ? Colors.green
                        : theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),

          /// Toggle Switch
          Switch(
            value: isAvailable,
            activeColor: AppColors.primary,
            onChanged:
                (
                  value,
                ) {
                  onToggle(
                    value,
                  );
                },
          ),
        ],
      ),
    );
  }
}
