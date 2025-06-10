import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/presentation/cubit/validation/validation_state.dart';

class ValidationCubit extends Cubit<ValidationState> {
  ValidationCubit() : super(ValidationState());
  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");


  void validateEmail(String email) {
    if (email.isEmpty) {
      emit(state.copyWith(emailerrorText: "Email cannot be empty"));
    } else if (!emailRegex.hasMatch(email)) {
      emit(state.copyWith(emailerrorText: "Invalid email"));
    } else {
      emit(state.copyWith(emailerrorText: null));
    }
  }

  void validatePassword(String password) {
    if (password.isEmpty) {
      emit(state.copyWith(passworderrorText: "Password cannot be empty"));
    } else if (password.length < 6) {
      emit(state.copyWith(
          passworderrorText: "Password must be at least 5 characters long"));
    } else {
      emit(state.copyWith(passworderrorText: null));
    }
  }

  void clearValidation() {
  emit(ValidationState(emailerrorText: null, passworderrorText: null));
}

}
