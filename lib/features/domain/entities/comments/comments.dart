import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable{
  final String ?commentId;
  final String ?userId;
  final String? username;
  final String? profileUrl;
  final String ?description;
  final String ?postId;
  final Timestamp? createdAt;
  final List<String>? likes;
  final num ?totalReplys;

  const CommentEntity(
      { this.userId,  this.username,  this.profileUrl, this.commentId, this.description, this.postId, this.createdAt, this.likes, this.totalReplys});
      
        @override

        List<Object?> get props => [userId, username, profileUrl,commentId,description,postId,createdAt,likes,totalReplys];
}
