import 'package:social_media/features/domain/entities/user/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  //credentials

  Future<void> registerUser(UserEntity user);
  Future<void> loginUser(UserEntity user);
  Future<bool> islogin();
  Future<void> logOut();

  //User
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Future<String> googleSignIn();
}
