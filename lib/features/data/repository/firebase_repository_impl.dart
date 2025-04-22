import 'dart:io';
import 'package:social_media/features/data/data_sources/remote_data_source/cloudinary/cloudinary_data_source.dart';


import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/comment_remote_data_source/comment_remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/credential_remote_data_source/credential_remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/post_remote_data_souce/post_remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/reply_remote_data_source/reply_remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/user_remote_data_source/user_remote_data_source.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/entities/savedposts/savedposts_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
 
  final UserRemoteDataSource userRemoteDataSource;
  final CloudinaryRepository cloudinaryRepository;
  final CredentialRemoteDataSource credentialRemoteDataSource;
  final CommentRemoteDataSource commentRemoteDataSource;
  final PostRemoteDataSource postRemoteDataSource;
  final ReplyRemoteDataSource replyRemoteDataSource;

  FirebaseRepositoryImpl(
      {
        required this.replyRemoteDataSource,
        required this.postRemoteDataSource,
      required this.commentRemoteDataSource,
      required this.credentialRemoteDataSource,
      required this.userRemoteDataSource,
     
      required this.cloudinaryRepository});

//users
  @override
  Future<void> createUser(UserEntity user) async =>
      credentialRemoteDataSource.createUser(user);

  @override
  Future<void> followUser(UserEntity user) async {
    print('repo call');
    return userRemoteDataSource.followUser(user);
  }

  @override
  Future<String> getCurrentUid() async =>
      credentialRemoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      userRemoteDataSource.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) =>
      userRemoteDataSource.getUsers(user);

  @override
  Future<void> updateUser(UserEntity user) async =>
      userRemoteDataSource.updateUser(user);

  //credential
  @override
  Future<bool> islogin() async => credentialRemoteDataSource.islogin();

  @override
  Future<void> logOut() async => credentialRemoteDataSource.logOut();

  @override
  Future<void> loginUser(UserEntity user) async =>
      credentialRemoteDataSource.loginUser(user);

  @override
  Future<void> registerUser(UserEntity user) async =>
      credentialRemoteDataSource.registerUser(user);

  @override
  Future<String> googleSignIn() async =>
      credentialRemoteDataSource.googleSignIn();

  @override
  Future<void> createUseWithImageUseCase(UserEntity user, String profileUrl) =>
      credentialRemoteDataSource.createUserWithImage(user, profileUrl);

  //cloudinary

  @override
  Future<String> uploadImageToStorage(
          File? imageFile, bool isPost, String childName) =>
      cloudinaryRepository.uploadImageToStorage(imageFile, childName, isPost);

//posts
  @override
  Future<void> createPost(PostEntity post) =>
      postRemoteDataSource.createPost(post);

  @override
  Future<void> deletePost(PostEntity post) =>
      postRemoteDataSource.deletePost(post);

  @override
  Future<void> likePost(PostEntity post) => postRemoteDataSource.likePost(post);

  @override
  Stream<List<PostEntity>> readPost(PostEntity post) =>
      postRemoteDataSource.readPost(post);

  @override
  Future<void> updatePost(PostEntity post) =>
      postRemoteDataSource.updatePost(post);

  @override
  Stream<List<PostEntity>> getSinglePost(String postId) =>
      postRemoteDataSource.getSinglePost(postId);

  @override
  Future<void> savePost(String postId, String userId) =>
      postRemoteDataSource.savePost(postId, userId);

  @override
  Stream<List<SavedpostsEntity>> readsavedPost(String userId) {
    return postRemoteDataSource.readSavedPost(userId);
  }

  @override
  Future<List<PostEntity>> likepage() {
    return postRemoteDataSource.likepage();
  }
//comments

  @override
  Future<void> createComment(CommentEntity comment) =>
      commentRemoteDataSource.createComment(comment);

  @override
  Future<void> deleteComment(CommentEntity comment) =>
      commentRemoteDataSource.deleteComment(comment);

  @override
  Future<void> likeComment(CommentEntity comment) =>
      commentRemoteDataSource.likeComment(comment);

  @override
  Stream<List<CommentEntity>> readComment(String postId) =>
      commentRemoteDataSource.readComment(postId);

  @override
  Future<void> updateComment(CommentEntity comment) =>
      commentRemoteDataSource.updateComment(comment);

//replys
  @override
  Future<void> createReply(ReplyEntity reply) async =>
      replyRemoteDataSource.createReply(reply);

  @override
  Future<void> deleteReply(ReplyEntity reply) =>
      replyRemoteDataSource.deleteReply(reply);

  @override
  Future<void> likeReply(ReplyEntity reply) =>
      replyRemoteDataSource.likeReply(reply);

  @override
  Stream<List<ReplyEntity>> readReply(ReplyEntity reply) =>
      replyRemoteDataSource.readReply(reply);
  @override
  Future<void> updateReply(ReplyEntity reply) =>
      replyRemoteDataSource.updateReply(reply);
}
