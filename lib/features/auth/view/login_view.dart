import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_drop/core/routing/app_router.dart';
import 'package:one_drop/core/theme/app_colors.dart';
import 'package:one_drop/core/validator/phone_validator.dart';
import 'package:one_drop/shared/widgets/app_button.dart';
import 'package:one_drop/shared/widgets/top_curve_clipper.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_text.dart';
import '../../../core/theme/app_spacing.dart';
import '../viewmodel/auth_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// Top Curve Header
          ClipPath(
            clipper: TopCurveClipper(),
            child: Container(
              height: 350,
              width: double.infinity,
              color: AppColors.primary,
              child: Column(
                children: [
                  AppSpacing.h50,
                  Center(
                    child: Image.asset(
                      'assets/icons/app_icon.png',
                      height: 250,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Main Content
          SafeArea(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSpacing.h200,

                  /// App Name
                  Text(
                    AppText.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.scaffoldBackground,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  AppSpacing.h100,

                  /// Title
                  Text(
                    AppText.welcomeBack,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  AppSpacing.h8,

                  /// Subtitle
                  Text(
                    AppText.loginSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  AppSpacing.h32,

                  /// Phone Input
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Country Code Box
                      Container(
                        height: 55.8,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Theme.of(context).hintColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CountryFlag.fromCountryCode(
                              "IN",
                              theme: const EmojiTheme(size: 20),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "+91",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),

                      AppSpacing.w8,

                      /// Phone Field
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _phoneController,
                            validator: PhoneValidator.validateIndian,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: InputDecoration(
                              hintText: "Phone number",
                              helperText: " ",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              errorStyle: const TextStyle(height: 0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  AppSpacing.h24,

                  /// Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: AppButton(
                      text: AppText.continueText,
                      isLoading: authVM.isLoading,
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await authVM.sendOtp(
                            _phoneController.text.trim(),
                          );

                          if (authVM.verificationId != null && context.mounted) {
                            Navigator.pushNamed(
                              context,
                              AppRouter.otp,
                              arguments: {
                                "phone": _phoneController.text.trim(),
                                "verificationId": authVM.verificationId,
                              },
                            );
                          }
                        }
                      },
                    ),
                  ),

                  const Spacer(),

                  /// Divider
                  Divider(
                    color: AppColors.textSecondary,
                  ),

                  /// Terms Text
                  Center(
                    child: Text(
                      AppText.termsNote,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),

                  AppSpacing.h16,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}