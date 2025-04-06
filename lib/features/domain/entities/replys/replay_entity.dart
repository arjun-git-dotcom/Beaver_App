import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReplyEntity extends Equatable {
  final String? replyId;
  final String? commentId;
  final String? postId;
  final String? userId;
  final String? username;
  final String? profileUrl;
  final String? description;
  final Timestamp? createdAt;
  final List<String>? likes;

  const ReplyEntity(
      {this.replyId,
      this.commentId,
      this.postId,
      this.userId,
      this.username,
      this.profileUrl,
      this.description,
      this.createdAt,
      this.likes});
  @override
  List<Object?> get props => [
        replyId,
        commentId,
        postId,
        userId,
        username,
        profileUrl,
        description,
        createdAt,
        likes
      ];
}
