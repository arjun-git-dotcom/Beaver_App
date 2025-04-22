import 'package:social_media/features/domain/entities/user/user_entity.dart';

abstract class CredentialRemoteDataSource {
  Future<void> createUser(UserEntity user);
  Future<String> getCurrentUid();
  Future<String> googleSignIn();
  Future<void> registerUser(UserEntity user);
  Future<void> createUserWithImage(UserEntity user, String profileUrl);
  Future<void> loginUser(UserEntity user);
  Future<bool> islogin();
  Future<void> logOut();
}
