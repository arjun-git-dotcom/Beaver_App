import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/login_user_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/register_user_usecase.dart';

import 'package:social_media/features/presentation/cubit/credential/credential_state.dart';
import 'package:social_media/features/presentation/utils/validation_toast.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final LoginUserUsecase loginUserUsecase;
  final RegisterUserUsecase registerUserUsecase;

  CredentialCubit({
    required this.loginUserUsecase,
    required this.registerUserUsecase,
  }) : super(CredentialInitial());

  Future<void> login({required String email, required String password}) async {
    emit(CredentialLoading());

    try {
      await loginUserUsecase.call(UserEntity(email: email, password: password));
      validateAndShowToast(email, password);
      emit(CredentialSuccess());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> register({required UserEntity user}) async {
    emit(CredentialLoading());

    try {
      await registerUserUsecase.call(user);
      validateAndShowToastRegistration(user);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }
}
