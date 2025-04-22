import 'package:social_media/features/domain/entities/comments/comments.dart';

abstract class CommentRemoteDataSource {

    Future<void> createComment(CommentEntity comment);
  Future<void> updateComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComment(String postId);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);
}