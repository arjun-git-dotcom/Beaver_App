import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';

class ReplyModel extends ReplyEntity {
  final String? replyId;
  final String? commentId;
  final String? postId;
  final String? userId;
  final String? username;
  final String? profileUrl;
  final String? description;
  final Timestamp? createdAt;
  final List<String>? likes;
  ReplyModel(
      {this.replyId,
      this.commentId,
      this.postId,
      this.userId,
      this.username,
      this.profileUrl,
      this.description,
      this.createdAt,
      this.likes})
      : super(replyId, commentId, postId, userId, username, profileUrl,
            description, createdAt, likes);

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
        likes: snapshot['likes']);
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
