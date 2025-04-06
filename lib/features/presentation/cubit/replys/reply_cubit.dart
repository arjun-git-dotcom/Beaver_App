import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/replys/create_reply_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/replys/delete_reply_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/replys/like_reply_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/replys/read_reply_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/replys/update_reply_usecase.dart';
import 'package:social_media/features/presentation/cubit/replys/reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  final CreateReplyUsecase createReplyUsecase;
  final DeleteReplyUsecase deleteReplyUsecase;
  final LikeReplyUsecase likeReplyUsecase;
  final ReadReplyUsecase readReplyUsecase;
  final UpdateReplyUsecase updateReplyUsecase;
  ReplyCubit(
      {required this.createReplyUsecase,
      required this.deleteReplyUsecase,
      required this.likeReplyUsecase,
      required this.readReplyUsecase,
      required this.updateReplyUsecase})
      : super(ReplyInitial());

  Future<void> createReply({required ReplyEntity reply}) async {
    try {
      await createReplyUsecase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> deleteReply({required ReplyEntity reply}) async {
    try {
      await deleteReplyUsecase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> likeReply({required ReplyEntity reply}) async {
    try {
      await likeReplyUsecase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> readReply({required ReplyEntity reply}) async {
    final streamResponse = readReplyUsecase.call(reply);
    try {
      streamResponse.listen((reply) {
        emit(ReplySuccess(reply: reply));
      });
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> updateReply({required ReplyEntity reply}) async {
    try {
      await updateReplyUsecase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }
}
