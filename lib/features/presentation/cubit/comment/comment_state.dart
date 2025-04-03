import 'package:equatable/equatable.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';

abstract class CommentState extends Equatable {}

class CommentLoading extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentIntial extends CommentState {
  @override
  List<Object?> get props => [];
}

class CommentSuccess extends CommentState {
  final List<CommentEntity> comments;
  CommentSuccess({required this.comments});
  @override
  List<Object?> get props => [comments];
}

class CommentFailure extends CommentState {
  @override
  List<Object?> get props => [];
}
