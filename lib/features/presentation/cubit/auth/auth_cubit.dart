import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_current_uuid_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/google_signin_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/is_login_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/logout_usecase.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LogoutUsecase logoutUsecase;
  final IsLoginUsecase isLoginUsecase;
  final GetCurrentUuidUsecase getCurrentUuidUsecase;
  final GoogleSignInUsecase googleSignInUsecase;
  AuthCubit(
      {required this.logoutUsecase,
      required this.isLoginUsecase,
      required this.getCurrentUuidUsecase,
      required this.googleSignInUsecase})
      : super(AuthInitial());

  Future<void> appStarted(BuildContext context) async {
    try {
      bool isLogin = await isLoginUsecase.call();
      if (isLogin == true) {
        final uid = await getCurrentUuidUsecase.call();
        emit(Authenticated(uid: uid));
      }
    } catch (e) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = await getCurrentUuidUsecase.call();
      emit(Authenticated(
        uid: uid,
      ));
    } catch (e) {
      emit(UnAuthenticated());
    }
  }

  Future<void> googleSignIn() async {
 
    try {
      final uid = await googleSignInUsecase.call();
      emit(Authenticated(uid: uid));
    } on SocketException catch (_) {
      emit(UnAuthenticated());
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> logOut() async {
    try {
      await logoutUsecase.call();
      emit(UnAuthenticated());
    } catch (_) {
      emit(UnAuthenticated());
    }
  }
}
