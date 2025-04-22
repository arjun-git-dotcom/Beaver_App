import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/savedposts/savedposts_entity.dart';

abstract class PostRemoteDataSource {

   Future<void> createPost(PostEntity post);
  Future<void> updatePost(PostEntity post);
  Stream<List<PostEntity>> readPost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);
  Stream<List<PostEntity>> getSinglePost(String postId);
  Future<void> savePost(String postId, String userId);
  Stream<List<SavedpostsEntity>> readSavedPost(String userId);
  Future<List<PostEntity>> likepage();
}