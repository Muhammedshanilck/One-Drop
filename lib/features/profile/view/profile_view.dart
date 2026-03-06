import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:one_drop/core/theme/app_colors.dart';
import 'package:one_drop/shared/widgets/top_curve_clipper.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../auth/model/user_model.dart';

class ProfileView
    extends
        StatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  State<
    ProfileView
  >
  createState() => _ProfileViewState();
}

class _ProfileViewState
    extends
        State<
          ProfileView
        > {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () {
        context
            .read<
              AuthViewModel
            >()
            .loadUser();
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final authVm = context
        .watch<
          AuthViewModel
        >();
    final UserModel? user = authVm.user;
    final theme = Theme.of(
      context,
    );

    return Scaffold(
      body: Stack(
        children: [
          /// CURVED BACKGROUND
          ClipPath(
            clipper: TopCurveClipper(),
            child: Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(
                      .25,
                    ),
                    AppColors.primary.withOpacity(
                      .05,
                    ),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    "More",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  /// USER CARD
                  if (user ==
                      null)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(
                        16,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(
                              0xffFF5C8A,
                            ),
                            Color(
                              0xffFF2E63,
                            ),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              .15,
                            ),
                            blurRadius: 10,
                            offset: const Offset(
                              0,
                              6,
                            ),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                user.photoUrl !=
                                    null
                                ? NetworkImage(
                                    user.photoUrl!,
                                  )
                                : null,
                            child:
                                user.photoUrl ==
                                    null
                                ? Text(
                                    user.name
                                        .substring(
                                          0,
                                          1,
                                        )
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : null,
                          ),

                          const SizedBox(
                            width: 14,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  user.phone,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(
                    height: 16,
                  ),

                  /// REFER CARD
                  _menuCard(
                    title: "Refer a Friend",
                    subtitle: "Earn hearts by sharing",
                    icon: Icons.favorite_border,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  /// SETTINGS SECTION
                  Text(
                    "Support",
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  _menuTile(
                    "Feedback",
                  ),
                  _menuTile(
                    "About Us",
                  ),
                  _menuTile(
                    "Terms and Conditions",
                  ),
                  _menuTile(
                    "Privacy Policy",
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  /// LOGOUT
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirm = await _confirmLogout(
                          context,
                        );

                        if (confirm) {
                          await authVm.logout(
                            context,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.logout,
                      ),
                      label: const Text(
                        "Logout",
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  /// DELETE ACCOUNT
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirm = await _confirmDelete(
                          context,
                        );
                        if (confirm) {
                          await authVm.deleteAccount(
                            context,
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                      ),
                      label: const Text(
                        "Delete Account",
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Center(
                    child: Text(
                      "App Version 1.0.0",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// MENU CARD
  Widget _menuCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final theme = Theme.of(
      context,
    );

    return Container(
      padding: const EdgeInsets.all(
        18,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(
          14,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              .05,
            ),
            blurRadius: 8,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),

          const SizedBox(
            width: 12,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const Spacer(),

          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
        ],
      ),
    );
  }

  /// MENU TILE (DARK MODE FIXED)
  Widget _menuTile(
    String title,
  ) {
    final theme = Theme.of(
      context,
    );

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(
          12,
        ),
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: ListTile(
        title: Text(
          title,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }

  /// CONFIRM DELETE
  Future<
    bool
  >
  _confirmDelete(
    BuildContext context,
  ) async {
    return await showDialog(
          context: context,
          builder:
              (
                _,
              ) => AlertDialog(
                title: const Text(
                  "Delete Account",
                ),
                content: const Text(
                  "Are you sure you want to delete your account?",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        false,
                      );
                    },
                    child: const Text(
                      "Cancel",
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        true,
                      );
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<
    bool
  >
  _confirmLogout(
    BuildContext context,
  ) async {
    return await showDialog(
          context: context,
          builder:
              (
                _,
              ) => AlertDialog(
                title: const Text(
                  "Logout",
                ),
                content: const Text(
                  "Are you sure you want to logout from your account?",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        false,
                      );
                    },
                    child: const Text(
                      "Cancel",
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        true,
                      );
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
