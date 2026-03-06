class PhoneValidator {
  static String? validateIndian(
    String? value,
  ) {
    if (value ==
            null ||
        value.trim().isEmpty) {
      return "Phone number is required.";
    }

    final cleaned = value.trim();

    final regex = RegExp(
      r'^[6-9]\d{9}$',
    );

    if (!regex.hasMatch(
      cleaned,
    )) {
      return "Please enter a valid 10-digit mobile number.";
    }

    return null;
  }
}
