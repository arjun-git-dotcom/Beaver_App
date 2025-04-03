import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/comments/create_comment_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/comments/delete_comment_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/comments/like_comment_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/comments/read_comment_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/comments/update_comment_usecase.dart';
import 'package:social_media/features/presentation/cubit/comment/comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CreateCommentUsecase createCommentUsecase;
  final DeleteCommentUsecase deleteCommentUsecase;
  final LikeCommentUsecase likeCommentUsecase;
  final ReadCommentUsecase readCommentUsecase;
  final UpdateCommentUsecase updateCommentUsecase;
  CommentCubit(
      {required this.createCommentUsecase,
      required this.deleteCommentUsecase,
      required this.likeCommentUsecase,
      required this.readCommentUsecase,
      required this.updateCommentUsecase})
      : super(CommentIntial());

  Future<void> createComment(CommentEntity comment) async {
    try {
      await createCommentUsecase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> deleteComment(CommentEntity comment) async {
    try {
      await deleteCommentUsecase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> updateComment(CommentEntity comment) async {
    try {
      await updateCommentUsecase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> getComments(String postId) async {
    try {
      final streamResponse = readCommentUsecase.call(postId);
      streamResponse.listen((comments) {
        print(comments);
        emit(CommentSuccess(comments: comments));
      });
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> likeCommments(CommentEntity comment) async {
    try {
      await likeCommentUsecase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }
}
