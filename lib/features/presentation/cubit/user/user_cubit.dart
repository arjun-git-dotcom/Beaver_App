import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_users_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/update_user_usecase.dart';
import 'package:social_media/features/presentation/cubit/user/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUsecase updateUserUsecase;
  final GetUsersUsecase getUsersUsecase;
  UserCubit({required this.getUsersUsecase, required this.updateUserUsecase})
      : super(UserInitial());

  Future<void> updateUser(UserEntity user) async {
 
    try {
      await updateUserUsecase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> getUsers(UserEntity user) async {
    emit(UserLoading());

    try {
      final streamResponse = getUsersUsecase.call(user);
      streamResponse.listen((users) {
        emit(UserLoaded(users: users));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
