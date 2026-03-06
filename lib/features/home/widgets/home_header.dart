import 'package:flutter/material.dart';
import 'package:one_drop/core/theme/app_colors.dart';
import 'package:one_drop/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../auth/model/user_model.dart';

class HomeHeader
    extends
        StatelessWidget {
  final UserModel? user;

  const HomeHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme = Theme.of(
      context,
    );
    final themeProvider = context
        .watch<
          ThemeProvider
        >();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Avatar
        CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primary.withOpacity(
            0.1,
          ),
          backgroundImage:
              user?.photoUrl !=
                  null
              ? NetworkImage(
                  user!.photoUrl!,
                )
              : null,
          child:
              user?.photoUrl ==
                  null
              ? Text(
                  user?.name
                          .substring(
                            0,
                            1,
                          )
                          .toUpperCase() ??
                      "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                )
              : null,
        ),

        const SizedBox(
          width: 10,
        ),

        /// TEXT SECTION
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${user?.name ?? ""}",
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: 2,
            ),

            /// Location
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Transform.translate(
                    offset: const Offset(
                      -2,
                      0,
                    ),
                    child: Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  Text(
                    user?.districtName ??
                        "",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),

                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),

        const Spacer(),

        /// THEME TOGGLE BUTTON
        IconButton(
          icon: Icon(
            themeProvider.isDark
                ? Icons.dark_mode
                : Icons.light_mode,
            color: AppColors.primary,
          ),
          onPressed: () {
            themeProvider.toggleTheme();
          },
        ),
      ],
    );
  }
}
