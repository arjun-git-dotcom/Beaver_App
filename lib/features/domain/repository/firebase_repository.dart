import 'dart:io';

import 'package:social_media/features/domain/entities/posts/post_entity.dart';
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
}
