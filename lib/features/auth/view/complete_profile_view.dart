import 'package:flutter/material.dart';
import 'package:one_drop/core/service/location_service.dart';
import 'package:provider/provider.dart';
import 'package:one_drop/core/theme/app_colors.dart';
import 'package:one_drop/core/models/place_model.dart';
import '../../../core/routing/app_router.dart';
import '../../auth/repository/user_repository.dart';
import '../viewmodel/complete_profile_viewmodel.dart';

class CompleteProfileView
    extends
        StatelessWidget {
  const CompleteProfileView({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return ChangeNotifierProvider(
      create:
          (
            _,
          ) => CompleteProfileViewModel(
            UserRepository(),
            LocationService(),
          ),
      child: const _CompleteProfileBody(),
    );
  }
}

class _CompleteProfileBody
    extends
        StatelessWidget {
  const _CompleteProfileBody();

  @override
  Widget build(
    BuildContext context,
  ) {
    final vm = context
        .watch<
          CompleteProfileViewModel
        >();
    final theme = Theme.of(
      context,
    );

    final bool isDark =
        theme.brightness ==
        Brightness.dark;

    final fieldFill = isDark
        ? const Color(
            0xFF1E1E1E,
          )
        : AppColors.fieldFill;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Image
                    Center(
                      child: Image.asset(
                        "assets/images/otp1.png",
                        height: 200,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    /// Verified text
                    Center(
                      child: Text(
                        "Your mobile number has been verified successfully.",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    /// Title
                    Text(
                      "Almost there! 🩸",
                      style: theme.textTheme.headlineMedium,
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      "Help us identify your location.",
                      style: theme.textTheme.bodyMedium,
                    ),

                    const SizedBox(
                      height: 35,
                    ),

                    /// Name Field
                    TextField(
                      controller: vm.nameController,
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.primary,
                        ),
                        filled: true,
                        fillColor: fieldFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    /// Gender
                    Text(
                      "Gender",
                      style: theme.textTheme.bodyLarge,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Wrap(
                      spacing: 10,
                      children:
                          [
                            "Male",
                            "Female",
                            "Other",
                          ].map(
                            (
                              gender,
                            ) {
                              final isSelected =
                                  vm.selectedGender ==
                                  gender;

                              return ChoiceChip(
                                label: Text(
                                  gender,
                                ),
                                selected: isSelected,
                                onSelected:
                                    (
                                      _,
                                    ) => vm.setGender(
                                      gender,
                                    ),
                                selectedColor: AppColors.primary.withOpacity(
                                  0.2,
                                ),
                                backgroundColor: fieldFill,
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColors.primary
                                      : theme.dividerColor,
                                ),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary
                                      : theme.colorScheme.onSurface,
                                ),
                              );
                            },
                          ).toList(),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    /// Location Search
                    TextField(
                      controller: vm.locationController,
                      onChanged: vm.onSearchChanged,
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        hintText: "Search your city or area",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.primary,
                        ),
                        filled: true,
                        fillColor: fieldFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    /// AUTOCOMPLETE RESULTS
                    if (vm.searchResults.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: fieldFill,
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vm.searchResults.length,
                          itemBuilder:
                              (
                                context,
                                index,
                              ) {
                                final PlaceModel place = vm.searchResults[index];

                                return ListTile(
                                  leading: const Icon(
                                    Icons.location_on_outlined,
                                  ),
                                  title: Text(
                                    place.name,
                                  ),
                                  subtitle: Text(
                                    place.address,
                                  ),

                                  onTap: () {
                                    vm.selectPlace(
                                      place,
                                    );
                                  },
                                );
                              },
                        ),
                      ),
                  ],
                ),
              ),
            ),

            /// Bottom Button
            Padding(
              padding: const EdgeInsets.all(
                24,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed:
                      vm.isFormValid &&
                          !vm.isLoading
                      ? () async {
                          final success = await vm.saveProfile();

                          if (success &&
                              context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRouter.main,
                              (
                                _,
                              ) => false,
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                  child: vm.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Finish Setup",
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
