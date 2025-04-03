import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';

class CommentModel extends CommentEntity {
  final String commentId;
  final String userId;
  final String username;
  final String profileUrl;
  final String description;
  final String postId;
  final Timestamp createdAt;
  final List<String> likes;
  final num totalReplys;

  CommentModel(
      {required this.commentId,
      required this.userId,
      required this.username,
      required this.profileUrl,
      required this.description,
      required this.postId,
      required this.createdAt,
      required this.likes,
      required this.totalReplys})
      : super(
            userId: userId,
            username: username,
            profileUrl: profileUrl,
            commentId: commentId,
            description: description,
            postId: postId,
            createdAt: createdAt,
            likes: likes,
            totalReplys: totalReplys);

  factory CommentModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return CommentModel(
        commentId: snapshot['commentId'],
        userId: snapshot['userId'],
        username: snapshot['username'],
        profileUrl: snapshot['profileUrl'],
        description: snapshot['description'],
        postId: snapshot['postId'],
        createdAt: snapshot['createdAt'],
        likes: List.from(snap.get('likes')),
        totalReplys: snapshot['totalReplys']);
  }

  Map<String, dynamic> toJson() {
    return {
      "commentId": commentId,
      "userId": userId,
      "username": username,
      "profileUrl": profileUrl,
      "description": description,
      "postId": postId,
      "createdAt": createdAt,
      "likes": likes,
      "totalReplys": totalReplys
    };
  }
}
