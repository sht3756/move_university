String formatPhoneNumber(String input) {
  input = input.replaceAll(RegExp(r'\D'), '');
  if (input.length <= 3) {
    return input;
  } else if (input.length <= 7) {
    return '${input.substring(0, 3)}-${input.substring(3)}';
  } else {
    return '${input.substring(0, 3)}-${input.substring(3, 7)}-${input.substring(7)}';
  }
}