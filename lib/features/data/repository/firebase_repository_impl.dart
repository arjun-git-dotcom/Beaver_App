import 'dart:io';
import 'package:social_media/features/data/data_sources/remote_data_source/cloudinary/cloudinary_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/entities/savedposts/savedposts_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource firebaseRemoteDataSource;
  final CloudinaryRepository cloudinaryRepository;

  FirebaseRepositoryImpl(
      {required this.firebaseRemoteDataSource,
      required this.cloudinaryRepository});

  @override
  Future<void> createUser(UserEntity user) async =>
      firebaseRemoteDataSource.createUser(user);

  @override
  Future<void> followUser(UserEntity user) async {
    print('repo call');
    return firebaseRemoteDataSource.followUser(user);
  }

  @override
  Future<String> getCurrentUid() async =>
      firebaseRemoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      firebaseRemoteDataSource.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) =>
      firebaseRemoteDataSource.getUsers(user);
  @override
  Future<bool> islogin() async => firebaseRemoteDataSource.islogin();

  @override
  Future<void> logOut() async => firebaseRemoteDataSource.logOut();

  @override
  Future<void> loginUser(UserEntity user) async =>
      firebaseRemoteDataSource.loginUser(user);

  @override
  Future<void> registerUser(UserEntity user) async =>
      firebaseRemoteDataSource.registerUser(user);

  @override
  Future<void> updateUser(UserEntity user) async =>
      firebaseRemoteDataSource.updateUser(user);

  @override
  Future<String> googleSignIn() async =>
      firebaseRemoteDataSource.googleSignIn();

  @override
  Future<void> createUseWithImageUseCase(UserEntity user, String profileUrl) =>
      firebaseRemoteDataSource.createUserWithImage(user, profileUrl);

  @override
  Future<String> uploadImageToStorage(
          File? imageFile, bool isPost, String childName) =>
      cloudinaryRepository.uploadImageToStorage(imageFile, childName, isPost);

  @override
  Future<void> createPost(PostEntity post) =>
      firebaseRemoteDataSource.createPost(post);

  @override
  Future<void> deletePost(PostEntity post) =>
      firebaseRemoteDataSource.deletePost(post);

  @override
  Future<void> likePost(PostEntity post) =>
      firebaseRemoteDataSource.likePost(post);

  @override
  Stream<List<PostEntity>> readPost(PostEntity post) =>
      firebaseRemoteDataSource.readPost(post);

  @override
  Future<void> updatePost(PostEntity post) =>
      firebaseRemoteDataSource.updatePost(post);

  @override
  Stream<List<PostEntity>> getSinglePost(String postId) =>
      firebaseRemoteDataSource.getSinglePost(postId);

  @override
  Future<void> savePost(String postId, String userId) =>
      firebaseRemoteDataSource.savePost(postId, userId);

  @override
  Stream<List<SavedpostsEntity>> readsavedPost(String userId) {
    return firebaseRemoteDataSource.readSavedPost(userId);
  }

//comments

  @override
  Future<void> createComment(CommentEntity comment) =>
      firebaseRemoteDataSource.createComment(comment);

  @override
  Future<void> deleteComment(CommentEntity comment) =>
      firebaseRemoteDataSource.deleteComment(comment);

  @override
  Future<void> likeComment(CommentEntity comment) =>
      firebaseRemoteDataSource.likeComment(comment);

  @override
  Stream<List<CommentEntity>> readComment(String postId) =>
      firebaseRemoteDataSource.readComment(postId);

  @override
  Future<void> updateComment(CommentEntity comment) =>
      firebaseRemoteDataSource.updateComment(comment);

  @override
  Future<void> createReply(ReplyEntity reply) async =>
      firebaseRemoteDataSource.createReply(reply);

  @override
  Future<void> deleteReply(ReplyEntity reply) =>
      firebaseRemoteDataSource.deleteReply(reply);

  @override
  Future<void> likeReply(ReplyEntity reply) =>
      firebaseRemoteDataSource.likeReply(reply);

  @override
  Stream<List<ReplyEntity>> readReply(ReplyEntity reply ) =>
      firebaseRemoteDataSource.readReply( reply);
  @override
  Future<void> updateReply(ReplyEntity reply) =>
      firebaseRemoteDataSource.updateReply(reply);
}
