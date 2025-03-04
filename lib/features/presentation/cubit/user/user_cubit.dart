import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/follow_unfollow_user_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_users_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/update_user_usecase.dart';
import 'package:social_media/features/presentation/cubit/user/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final FollowUsecase followUsecase;
  final UpdateUserUsecase updateUserUsecase;
  final GetUsersUsecase getUsersUsecase;
  
  UserCubit(
    
      {
        required this.followUsecase,
        required this.getUsersUsecase,
      required this.updateUserUsecase,
      })
      : super(UserInitial()) {
    try {
      print('the new instance is $this');
    } catch (e, stacktrace) {
      print('error creating ${e}');
      print('the problem is $stacktrace');
    }
  }

  Future<void> updateUser(UserEntity user) async {
    try {
      await updateUserUsecase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> getUsers({required UserEntity user}) async {
    try {
      print('HIII');
      emit(UserLoading());

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

  Future<void> followUser({required UserEntity user}) async {
    try {
      await followUsecase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
