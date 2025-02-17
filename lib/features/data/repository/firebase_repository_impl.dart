import 'dart:io';
import 'package:social_media/features/data/data_sources/remote_data_source/cloudinary/cloudinary_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource firebaseRemoteDataSource;
  final CloudinaryRepository cloudinaryRepository;

  FirebaseRepositoryImpl({required this.firebaseRemoteDataSource,required this.cloudinaryRepository});

  @override
  Future<void> createUser(UserEntity user) async =>
      firebaseRemoteDataSource.createUser(user);

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
  Future<void> createPost(PostEntity post) {
    // TODO: implement createPost
    throw UnimplementedError();
  }

  @override
  Future<void> deletePost(PostEntity post) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<void> likePost(PostEntity post) {
    // TODO: implement likePost
    throw UnimplementedError();
  }

  @override
  Stream<List<PostEntity>> readPost(PostEntity post) {
    // TODO: implement readPost
    throw UnimplementedError();
  }

  @override
  Future<void> updatePost(PostEntity post) {
    // TODO: implement updatePost
    throw UnimplementedError();
  }
}
