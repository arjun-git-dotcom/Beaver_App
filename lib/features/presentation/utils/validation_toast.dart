import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/core/validator.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';

void validateAndShowToast(String email, String password) {
  final result = validate(email, password);

  result.fold((error) {
    String errorMessage = "";
    switch (error) {
      case ValidationError.invalidEmail:
        errorMessage = "invalid email, Please Try again";
        break;
      case ValidationError.weakPassword:
        errorMessage = "Password must be atleast 8 characters long";
        break;
    }
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: primaryColor,
        textColor: backgroundColor);
  }, (validUser) {});
}

validateAndShowToastRegistration(UserEntity user) {
  final result = validate(user.email!, user.password!);

  result.fold((error) {
    String errorMessage = "";

    switch (error) {
      case ValidationError.invalidEmail:
        errorMessage = "invalid email,Please Try again";
        break;
      case ValidationError.weakPassword:
        errorMessage = "Password must be atleast 8 characters long";
        break;
    }
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: primaryColor,
        textColor: backgroundColor);
  }, (validUser) {});
}
