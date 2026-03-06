import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:one_drop/core/theme/app_colors.dart';
import 'package:one_drop/features/donates/view/donor_form_view.dart';
import 'package:one_drop/features/donates/view/donor_list_view.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

class DonatesView
    extends
        StatelessWidget {
  const DonatesView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final user = context
        .watch<
          AuthViewModel
        >()
        .user;

    if (user ==
        null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "User not logged in",
          ),
        ),
      );
    }

    /// If blood group not set → user is not a donor yet
    if (user.bloodGroup ==
        null) {
      return _registerDonorUI(
        context,
      );
    }

    /// If blood group exists → show donors list
    return const DonorListView();
  }

  /// REGISTER DONOR UI
  Widget _registerDonorUI(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Donates",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.volunteer_activism,
              size: 80,
              color: AppColors.primary,
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              "Register as a Donor",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              "Register as a donor and manage your blood donation availability.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (
                            _,
                          ) => const DonorFormView(),
                    ),
                  );
                },
                child: const Text(
                  "Become a Donor",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
