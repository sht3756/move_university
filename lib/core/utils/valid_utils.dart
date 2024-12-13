bool isNameValid(String name) => name.isNotEmpty && name.length >= 2;

bool isEmailValid(String email) {
  final emailRegex =
  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}

bool isPhoneValid(String phone) {
  final phoneRegex = RegExp(r'^010-\d{4}-\d{4}$');
  return phoneRegex.hasMatch(phone);
}

bool isFormValid(String name, String email, String phone) {
  return isNameValid(name) &&
      isEmailValid(email) &&
      isPhoneValid(phone);
}
