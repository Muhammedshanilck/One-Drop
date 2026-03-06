import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpInputField
    extends
        StatelessWidget {
  final Function(
    String,
  )
  onCompleted;

  const OtpInputField({
    super.key,
    required this.onCompleted,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final defaultTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
    );

    final focusedTheme = defaultTheme.copyDecorationWith(
      border: Border.all(
        color: Theme.of(
          context,
        ).primaryColor,
        width: 2,
      ),
    );

    return Pinput(
      length: 6,
      keyboardType: TextInputType.number,
      defaultPinTheme: defaultTheme,
      focusedPinTheme: focusedTheme,
      onCompleted: onCompleted,
    );
  }
}
