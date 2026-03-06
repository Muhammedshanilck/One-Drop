class PhoneFormatter {
  static String mask(String phone) {
    if (phone.length < 4) return phone;

    return "${phone.substring(0, 2)}******${phone.substring(phone.length - 2)}";
  }
}