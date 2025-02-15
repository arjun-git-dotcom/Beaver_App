import 'package:dartz/dartz.dart';

enum ValidationError { invalidEmail, weakPassword }

class Validator {
  static Either<ValidationError, String> validateEmail(String input) {
    if (!input.contains("@") || !input.contains(".")) {
      return const Left(ValidationError.invalidEmail);
    }

    return Right(input);
  }

  static Either<ValidationError, String> validatePassword(String input) {
    if (input.length < 8) {
      return const Left(ValidationError.weakPassword);
    }
    return right(input);
  }
}
