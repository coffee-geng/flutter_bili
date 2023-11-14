bool isNotEmptyOrWhitespace(String? text) {
  return text?.trim().isNotEmpty ?? false;
}

bool isEmptyOrWhitespaces(String? text) {
  return text?.trim().isEmpty ?? true;
}
