import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUsecase getSingleUserUsecase;
  GetSingleUserCubit({required this.getSingleUserUsecase})
      : super(GetSingleUserInitial());

  Future<void> getSingleUser({required String uid}) async {
    emit(GetSingleUserLoading());

    try {
      final streamResponse = getSingleUserUsecase.call(uid);

      streamResponse.listen((users) {

        if (users.isNotEmpty) {
    emit(GetSingleUserLoaded(user: users.first));
  } else {
   
    emit(GetSingleUserFailure()); 
  }
      });
    } on SocketException catch (_) {
      emit(GetSingleUserFailure());
    } catch (_) {
      emit(GetSingleUserFailure());
    }
  }
}
