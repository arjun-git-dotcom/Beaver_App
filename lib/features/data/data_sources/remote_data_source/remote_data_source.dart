import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/savedposts/savedposts_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  //credentials

  Future<void> registerUser(UserEntity user);
  Future<void> createUserWithImage(UserEntity user, String profileUrl);
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
  Future<void> followUser(UserEntity user);

//post
  Future<void> createPost(PostEntity post);
  Future<void> updatePost(PostEntity post);
  Stream<List<PostEntity>> readPost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);
  Stream<List<PostEntity>> getSinglePost(String postId);
  Future<void> savePost(String postId, String userId);
  Stream<List<SavedpostsEntity>> readSavedPost(String userId);


  //comment
  Future<void> createComment(CommentEntity comment);
  Future<void> updateComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComment(String postId);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);

}
