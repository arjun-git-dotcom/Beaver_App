import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/create_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/delete_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/like_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/read_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/update_post_usecase.dart';
import 'package:social_media/features/presentation/cubit/posts/post_state.dart';


class PostCubit extends Cubit<PostState> {
  final CreatePostUsecase createPostUsecase;
  final DeletePostUsecase deletePostUsecase;
  final UpdatePostUsecase updatePostUsecase;
  final LikePostUsecase likePostUsecase;
  final ReadPostUsecase readPostUsecase;
  PostCubit(
      {required this.createPostUsecase,
      required this.deletePostUsecase,
      required this.updatePostUsecase,
      required this.likePostUsecase,
      required this.readPostUsecase})
      : super(PostInitial());

  Future<void> getPost({required PostEntity post}) async {
    emit(PostLoading());

    try {
      final streamResponse = readPostUsecase.call(post);
      streamResponse.listen((posts) {
        emit(PostLoaded(posts: posts));
      });
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }



   Future<void> updatePost({required PostEntity post} ) async {
 
    try {
      await updatePostUsecase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

   Future<void> createPost({required PostEntity post}) async {
 
    try {
      await createPostUsecase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }


   Future<void> likePost({required PostEntity post}) async {
 
    try {
      await likePostUsecase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }


   Future<void> deletePost({required PostEntity post}) async {
 
    try {
      await deletePostUsecase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }
}
