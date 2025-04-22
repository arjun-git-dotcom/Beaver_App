import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';

class ReplyModel extends ReplyEntity {
  @override
  final String? replyId;
  @override
  final String? commentId;
  @override
  final String? postId;
  @override
  final String? userId;
  @override
  final String? username;
  @override
  final String? profileUrl;
  @override
  final String? description;
  @override
  final Timestamp? createdAt;
  @override
  final List<String>? likes;
  const ReplyModel(
      {this.replyId,
      this.commentId,
      this.postId,
      this.userId,
      this.username,
      this.profileUrl,
      this.description,
      this.createdAt,
      this.likes})
      : super(
            replyId: replyId,
            commentId: commentId,
            postId: postId,
            userId: userId,
            username: username,
            profileUrl: profileUrl,
            description: description,
            createdAt: createdAt,
            likes: likes);

  factory ReplyModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ReplyModel(
        replyId: snapshot["replyId"],
        commentId: snapshot["commentId"],
        postId: snapshot["postId"],
        userId: snapshot["userId"],
        username: snapshot["username"],
        profileUrl: snapshot["profileUrl"],
        description: snapshot['description'],
        createdAt: snapshot['createdAt'],
        likes: List.from(snap.get('likes')));
  }

  Map<String, dynamic> toJson() {
    return {
      "replyId": replyId,
      "commentId": commentId,
      "postId": postId,
      "userId": userId,
      "username": username,
      "profileUrl": profileUrl,
      "description": description,
      "createdAt": createdAt,
      "likes": likes
    };
  }
}
