class ValidationState {
  final String? emailerrorText;
  final String? passworderrorText;

  ValidationState({this.emailerrorText, this.passworderrorText,});

  ValidationState copyWith(
      {String? emailerrorText, String? passworderrorText,String?loginerrorText}) {
    return ValidationState(
        emailerrorText: emailerrorText, passworderrorText: passworderrorText,);
  }
}
