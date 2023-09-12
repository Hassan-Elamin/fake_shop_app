mixin Validator {
  static bool nullSafetyValidate(String? input) =>
      (input ?? '').isNotEmpty ? true : false;

  static bool isUsernameValidated(String input) =>
      input.length > 4 ? true : false;

  static String? usernameValidator(String? value) {
    if (!isUsernameValidated(value ?? '')) {
      return 'please enter a valid username';
    } else {
      return null;
    }
  }

  static bool isEmailValidated(String input) =>
      input.contains('@') || input.contains('.com') ? true : false;

  static String? emailValidator(String? value) {
    if (!isEmailValidated(value ?? '')) {
      return "email is not validated , please enter validate email";
    } else {
      return null;
    }
  }

  static bool isPasswordValidated(String input) =>
      input.length >= 8 ? true : false;

  static String? passwordValidator(String? value) {
    if (!isPasswordValidated(value ?? '')) {
      return "password not validated";
    } else {
      return null;
    }
  }

  static bool isPasswordConfirmValidated(String password, String input) =>
      input == password ? true : false;

  static bool isBirthDateValidated(DateTime date) {
    if (date.isBefore(DateTime(DateTime.now().year - 16))) {
      return true;
    } else {
      return false;
    }
  }

  // ignore: body_might_complete_normally_nullable
  static String? birthDateValidator(String? value) {
    if (!isBirthDateValidated(
        DateTime.tryParse(value ?? '') ?? DateTime.now())) {
      'birthdate is not validated';
    } else {
      return null;
    }
  }
}
