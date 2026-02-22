String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }

  /// Basic email validation
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  return null;
}

String? confirmPasswordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  return null;
}

String? branchNameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the branch name';
  }
  return null;
}

String? branchAddressValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the branch address';
  }
  return null;
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  return null;
}
