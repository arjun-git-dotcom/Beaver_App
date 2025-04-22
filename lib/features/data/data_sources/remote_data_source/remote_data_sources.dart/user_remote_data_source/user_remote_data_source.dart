import 'package:social_media/features/domain/entities/user/user_entity.dart';

abstract class UserRemoteDataSource {

 Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);

  Future<void> updateUser(UserEntity user);

  Future<void> followUser(UserEntity user);
  


}