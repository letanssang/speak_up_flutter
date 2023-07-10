String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email is required';
  }
  const String regex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final RegExp regExp = RegExp(regex);
  if (!regExp.hasMatch(email)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validateUserName(String? userName) {
  if (userName == null || userName.isEmpty) {
    return 'User name is required';
  }
  if (userName.length < 6) {
    return 'User name must be at least 6 characters';
  }
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password is required';
  }
  if (password.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}
