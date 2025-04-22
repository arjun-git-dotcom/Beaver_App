import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/credential_remote_data_source/credential_remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/reply_remote_data_source/reply_remote_data_source.dart';
import 'package:social_media/features/data/model/reply/reply_model.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';

class ReplyRemoteDataSourceImpl implements ReplyRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final CredentialRemoteDataSource credentialRemoteDataSource;
  ReplyRemoteDataSourceImpl(
      {required this.firebaseFirestore,
      required this.credentialRemoteDataSource});

  @override
  Future<void> createReply(ReplyEntity reply) async {
    final collection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply)
        .doc(reply.replyId);

    final newreply = ReplyModel(
            replyId: reply.replyId!,
            commentId: reply.commentId,
            userId: reply.userId!,
            username: reply.username!,
            description: reply.description!,
            likes: const [],
            createdAt: reply.createdAt!,
            postId: reply.postId!,
            profileUrl: reply.profileUrl!)
        .toJson();
    try {
      final replyDocRef = await collection.get();
      if (!replyDocRef.exists) {
        collection.set(newreply);
      } else {
        collection.update(newreply);
      }
    } catch (e) {
      print('some errors occured $e');
    }
  }

  @override
  Future<void> deleteReply(ReplyEntity replay) async {
    final replayCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(replay.postId)
        .collection(FirebaseConstants.comment)
        .doc(replay.commentId)
        .collection(FirebaseConstants.reply);

    try {
      replayCollection.doc(replay.replyId).delete().then((value) {
        final commentCollection = firebaseFirestore
            .collection(FirebaseConstants.posts)
            .doc(replay.postId)
            .collection(FirebaseConstants.comment)
            .doc(replay.commentId);

        commentCollection.get().then((value) {
          if (value.exists) {
            final totalReplays = value.get('totalReplays');
            commentCollection.update({"totalReplays": totalReplays - 1});
            return;
          }
        });
      });
    } catch (e) {
      print("some error occured $e");
    }
  }

  @override
  Future<void> likeReply(ReplyEntity reply) async {
    String uid = await credentialRemoteDataSource.getCurrentUid();
    final collection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply)
        .doc(reply.replyId);

    try {
      final replyDocRef = await collection.get();
      if (replyDocRef.exists) {
        final likes = replyDocRef.get('likes');
        if (!likes.contains(uid)) {
          collection.update({
            "likes": FieldValue.arrayUnion([uid])
          });
        } else {
          collection.update({
            "likes": FieldValue.arrayRemove([uid])
          });
        }
      }
    } catch (e) {
      print('some error occured $e');
    }
  }

  @override
  Stream<List<ReplyEntity>> readReply(ReplyEntity reply) {
    final collection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply);

    return collection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((e) => ReplyModel.fromSnapshot(e)).toList();
    });
  }

  @override
  Future<void> updateReply(ReplyEntity reply) async {
    final collection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply);

    Map<String, dynamic> replyInfo = {};

    if (reply.description != "" || reply.description != null) {
      replyInfo['description'] = reply.description;
      collection.doc(reply.replyId).update(replyInfo);
    }
  }
}
