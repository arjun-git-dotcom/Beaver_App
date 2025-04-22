import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/credential_remote_data_source/credential_remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/post_remote_data_souce/post_remote_data_source.dart';
import 'package:social_media/features/data/model/post/post_model.dart';
import 'package:social_media/features/data/model/savedpost/savedpost_model.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/savedposts/savedposts_entity.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final CredentialRemoteDataSource credentialRemoteDataSource;
  PostRemoteDataSourceImpl({
    required this.credentialRemoteDataSource,
    required this.firebaseFirestore});
  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);
    final newpost = PostModel(
      postId: post.postId,
      creatorUid: post.creatorUid,
      username: post.username,
      description: post.description,
      postImageUrl: post.postImageUrl,
      likes: const [],
      totalLikes: 0,
      totalComments: 0,
      createAt: post.createAt,
      userProfileUrl: post.userProfileUrl,
    ).toJson();
    try {
      final postDocRef = await postCollection.doc(post.postId).get();
      if (!postDocRef.exists) {
        postCollection
            .doc(post.postId)
            .set(newpost, SetOptions(merge: true))
            .then((value) {
          final userCollecton = firebaseFirestore
              .collection(FirebaseConstants.users)
              .doc(post.creatorUid);

          userCollecton.get().then((value) {
            if (value.exists) {
              final totalPosts = value.get("totalPosts");
              userCollecton.update({"totalPosts": totalPosts + 1});
              return;
            }
          });
        });
      } else {
        postCollection.doc(post.postId).update(newpost);
      }
    } catch (e) {
      print('some error occured $e');
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);

    try {
      postCollection.doc(post.postId).delete();
    } catch (e) {
      print('some error occured $e');
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);
    final currentuid = await credentialRemoteDataSource.getCurrentUid();
    final postRef = postCollection.doc(post.postId);
    final postRefget = await postRef.get();

    if (postRefget.exists) {
      List likes = postRefget.get('likes');
      if (likes.contains(currentuid)) {
        postCollection.doc(post.postId).update({
          'likes': FieldValue.arrayRemove([currentuid]),
          'totalLikes': FieldValue.increment(-1)
        });
      } else {
        postCollection.doc(post.postId).update({
          'likes': FieldValue.arrayUnion([currentuid]),
          "totalLikes": FieldValue.increment(1)
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPost(PostEntity post) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapShot(e)).toList());
  }

  @override
  Stream<List<PostEntity>> getSinglePost(String postId) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .orderBy("createAt", descending: true)
        .where("postId", isEqualTo: postId);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapShot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);

    Map<String, dynamic> postInfo = {};

    if (post.description != "" || post.description != null) {
      postInfo['description'] = post.description;
    }

    if (post.postImageUrl != "" || post.postImageUrl != null) {
      postInfo['postImageUrl'] = post.postImageUrl;
      postCollection.doc(post.postId).update(postInfo);
    }
  }

  @override
  Future<void> savePost(String postId, String userId) async {
    var savedPosts = firebaseFirestore.collection('saved posts');
    var existing = await savedPosts
        .where("userId", isEqualTo: userId)
        .where("postId", isEqualTo: postId)
        .get();

    if (existing.docs.isEmpty) {
      savedPosts.add({
        "userId": userId,
        "postId": postId,
        "savedAt": FieldValue.serverTimestamp()
      });
    } else {
      print('post already present');
    }
  }

  @override
  Stream<List<SavedpostsEntity>> readSavedPost(String userId) {
    final savedPostsuser = firebaseFirestore
        .collection("saved posts")
        .where("userId", isEqualTo: userId);

    var savedposts = savedPostsuser.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => SavedpostModel.fromSnapshot(e)).toList());
    print(savedposts);

    return savedposts;
  }

  @override
  Future<List<PostEntity>> likepage() async {
    final currentuid = credentialRemoteDataSource.getCurrentUid();
    final snapshot = await firebaseFirestore
        .collection("posts")
        .where("likes", arrayContains: currentuid)
        .get();

    return snapshot.docs.map((doc) => PostModel.fromSnapShot(doc)).toList();
  }
}
