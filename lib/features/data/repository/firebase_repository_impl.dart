import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource firebaseRemoteDataSource;

  FirebaseRepositoryImpl({required this.firebaseRemoteDataSource});

  @override
  Future<void> createUser(UserEntity user) async=>
      firebaseRemoteDataSource.createUser(user);

  @override
  Future<String> getCurrentUid() async=> firebaseRemoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      firebaseRemoteDataSource.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) =>
      firebaseRemoteDataSource.getUsers(user);
  @override
  Future<bool> islogin() async=> firebaseRemoteDataSource.islogin();

  @override
  Future<void> logOut()async => firebaseRemoteDataSource.logOut();

  @override
  Future<void> loginUser(UserEntity user)async =>
      firebaseRemoteDataSource.loginUser(user);

  @override
  Future<void> registerUser(UserEntity user) async=>
      firebaseRemoteDataSource.registerUser(user);

  @override
  Future<void> updateUser(UserEntity user) async=>
      firebaseRemoteDataSource.updateUser(user);




       @override
  Future<String> googleSignIn() async=>
      firebaseRemoteDataSource.googleSignIn();
}
