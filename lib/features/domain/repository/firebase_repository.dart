import 'dart:io';

import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/entities/savedposts/savedposts_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';

abstract class FirebaseRepository {
  //credential  features

  Future<void> registerUser(UserEntity user);
  Future<void> loginUser(UserEntity user);
  Future<bool> islogin();
  Future<void> logOut();
  Future<String> googleSignIn();

  //User features
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Future<void> followUser(UserEntity user);
  Future<void> callUser(receiverToken, callerName, callID);
  Future<String?> getfcmToken();

  //storage features

  Future<String> uploadImageToStorage(
      File? imageFile, bool isPost, String childName);

  Future<void> createUseWithImageUseCase(UserEntity user, String profileUrl);

  //post features

  Future<void> createPost(PostEntity post);
  Future<void> updatePost(PostEntity post);
  Stream<List<PostEntity>> readPost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);
  Stream<List<PostEntity>> getSinglePost(String postId);
  Future<void> savePost(String postId, String userId);
  Stream<List<SavedpostsEntity>> readsavedPost(String userId);
  Future<List<PostEntity>> likepage();

  //comment features
  Future<void> createComment(CommentEntity comment);
  Future<void> updateComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComment(String postId);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);

//replys
  Future<void> createReply(ReplyEntity reply);
  Future<void> updateReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> readReply(ReplyEntity reply);
  Future<void> deleteReply(ReplyEntity reply);
  Future<void> likeReply(ReplyEntity reply);
}
