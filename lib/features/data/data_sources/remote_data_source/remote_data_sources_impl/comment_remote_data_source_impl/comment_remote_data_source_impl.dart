import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/comment_remote_data_source/comment_remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/credential_remote_data_source/credential_remote_data_source.dart';
import 'package:social_media/features/data/model/comment/comment_model.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final CredentialRemoteDataSource credentialRemoteDataSource;
  CommentRemoteDataSourceImpl(
      {required this.firebaseFirestore,
      required this.credentialRemoteDataSource});

  @override
  Future<void> createComment(CommentEntity comment) async {
    var collection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(comment.postId)
        .collection(FirebaseConstants.comment)
        .doc(comment.commentId);
    final newcomment = CommentModel(
            commentId: comment.commentId!,
            userId: comment.userId!,
            username: comment.username!,
            description: comment.description!,
            likes: const [],
            totalReplys: 0,
            createdAt: comment.createdAt!,
            postId: comment.postId!,
            profileUrl: comment.profileUrl!)
        .toJson();

    try {
      final commentDocRef = await collection.get();
      if (!commentDocRef.exists) {
        collection.set(newcomment).then((value) {
          final postcollection = firebaseFirestore
              .collection(FirebaseConstants.posts)
              .doc(comment.postId);

          postcollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('totalComments');
              postcollection.update({"totalComments": totalComments + 1});
              return;
            }
          });
        });
      } else {
        collection.update(newcomment);
      }
    } catch (e) {
      print('some error occured $e');
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(comment.postId)
        .collection(FirebaseConstants.comment);
    try {
      commentCollection.doc(comment.commentId).delete();

      var postcollection = firebaseFirestore
          .collection(FirebaseConstants.posts)
          .doc(comment.postId);
      final value = await postcollection.get();

      if (value.exists) {
        postcollection.update({'totalcomments': FieldValue.increment(-1)});
      }
    } catch (e) {
      print('some errors occured $e');
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    String uid = await credentialRemoteDataSource.getCurrentUid();

    final commentDoc = firebaseFirestore
        .collection('posts')
        .doc(comment.postId)
        .collection('comments')
        .doc(comment.commentId);

    try {
      final commentDocget = await commentDoc.get();

      if (commentDocget.exists) {
        List value = commentDocget.get('likes');
        if (!value.contains(uid)) {
          await commentDoc.update({
            'totalLikes': FieldValue.increment(1),
            "likes": FieldValue.arrayUnion([uid])
          });
        } else {
          await commentDoc.update({
            'totalLikes': FieldValue.increment(-1),
            "likes": FieldValue.arrayRemove([uid])
          });
        }
      }
    } catch (e) {
      print('some errors occured $e');
    }
  }

  @override
  Stream<List<CommentEntity>> readComment(String postId) {
    print(postId);
    final commentCollection = firebaseFirestore
        .collection('posts')
        .doc(postId)
        .collection('comments');

    return commentCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((e) => CommentModel.fromSnapshot(e))
          .toList();
    });
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection('posts')
        .doc(comment.postId)
        .collection('comments')
        .doc(comment.commentId);

    Map<String, dynamic> commentInfo = {};

    if (comment.description != "" || comment.description != null) {
      commentInfo['description'] = comment.description;
      commentCollection.update(commentInfo);
    }
  }
}
