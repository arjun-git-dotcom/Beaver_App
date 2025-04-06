import 'package:equatable/equatable.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';

abstract class ReplyState extends Equatable {}

class ReplyLoading extends ReplyState {
  @override
  List<Object?> get props => [];
}

class ReplyInitial extends ReplyState {
  @override
  List<Object?> get props => [];
}

class ReplySuccess extends ReplyState {
  final List<ReplyEntity> reply;
  ReplySuccess({required this.reply});
  @override
  List<Object?> get props => [reply];
}

class ReplyFailure extends ReplyState {
  @override
  List<Object?> get props => [];
}
