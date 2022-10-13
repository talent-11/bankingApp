// ignore_for_file: unnecessary_null_comparison

extension ValidationService on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName{
    final nameRegExp = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword{
    // final passwordRegExp = RegExp(r'^(?=.*\d)(?=.*[a-zA-Z]).{8,}$');
    // final passwordRegExp = RegExp(r'^(?=.*\d){6,}$');
    // return passwordRegExp.hasMatch(this);
    return true;
  }

  bool get isNotNull{
    return this != null;
  }

  bool get isValidPhone{
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidReferralId{
    final referralIdRegExp = RegExp(r"^[a-zA-Z0-9]{6}$");
    return referralIdRegExp.hasMatch(this);
  }

}