import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class ReadCommentUsecase {
  final FirebaseRepository repository;
  ReadCommentUsecase({required this.repository});

  Stream<List<CommentEntity>> call(String postId) {
    return repository.readComment(postId);
  }
}
