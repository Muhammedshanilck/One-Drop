import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:one_drop/core/utils/phone_formatter.dart';
import 'package:one_drop/shared/widgets/app_button.dart';
import 'package:one_drop/shared/widgets/otp_inputfield.dart';
import '../viewmodel/otp_viewmodel.dart';
import '../../../core/routing/app_router.dart';

class OtpView
    extends
        StatefulWidget {
  final String phone;
  final String verificationId;

  const OtpView({
    super.key,
    required this.phone,
    required this.verificationId,
  });

  @override
  State<
    OtpView
  >
  createState() => _OtpViewState();
}

class _OtpViewState
    extends
        State<
          OtpView
        > {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () {
        context
            .read<
              OtpViewModel
            >()
            .initialize(
              phoneNumber: widget.phone,
              verificationId: widget.verificationId,
            );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final vm = context
        .watch<
          OtpViewModel
        >();

    /// Navigation listener
    WidgetsBinding.instance.addPostFrameCallback(
      (
        _,
      ) {
        if (!mounted) return;

        switch (vm.status) {
          case OtpStatus.successExistingUser:
            vm.resetStatus();
            Navigator.pushReplacementNamed(
              context,
              AppRouter.main,
            );
            break;

          case OtpStatus.successNewUser:
            vm.resetStatus();
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRouter.completeProfile,
              (
                route,
              ) => false,
            );
            break;

          case OtpStatus.error:
            vm.resetStatus();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              const SnackBar(
                content: Text(
                  "Invalid OTP",
                ),
              ),
            );
            break;

          default:
            break;
        }
      },
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 🔹 Image
            Image.asset(
              "assets/images/otp.png",
              height: 200,
            ),

            const SizedBox(
              height: 40,
            ),

            /// 🔹 Title
            Text(
              "Verify OTP",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium,
            ),

            const SizedBox(
              height: 12,
            ),

            /// 🔹 Subtitle
            Text(
              "Enter the 6-digit code sent to +91 ${PhoneFormatter.mask(widget.phone)}",
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: 32,
            ),

            /// 🔹 OTP Field
            OtpInputField(
              onCompleted: vm.setOtp,
            ),

            const SizedBox(
              height: 16,
            ),

            /// 🔹 Resend Section
            vm.canResend
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive the code?",
                      ),
                      TextButton(
                        onPressed: vm.resendOtp,
                        child: const Text(
                          "Resend OTP",
                        ),
                      ),
                    ],
                  )
                : Text(
                    "Resend OTP in ${vm.secondsRemaining} s",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

            const SizedBox(
              height: 32,
            ),

            /// 🔹 Verify Button
            AppButton(
              text: "Verify",
              isLoading:
                  vm.status ==
                  OtpStatus.loading,
              onPressed:
                  vm.enteredOtp.length ==
                      6
                  ? () {
                      vm.verifyOtp();
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
