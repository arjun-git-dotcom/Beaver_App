import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/get_single_post_usecase.dart';
import 'package:social_media/features/presentation/cubit/posts/get_single_post/get_single_post_state.dart';

class GetSinglePostCubit extends Cubit<GetSinglePostState> {
  final GetSinglePostUsecase getSinglePostUsecase;
  GetSinglePostCubit({required this.getSinglePostUsecase}) : super(GetSinglePostInitial());

  Future<void> getSinglePost({required String postId}) async {
    emit(GetSinglePostLoading());
    try {
      final streamedResponse = getSinglePostUsecase.call(postId);

      streamedResponse.listen((posts) {
        emit(GetSinglePostLoaded(post: posts.first));
      });
    } on SocketException catch (_) {
      emit(GetSinglePostFailure());
    } catch (_) {
      emit(GetSinglePostFailure());
    }
  }
}
