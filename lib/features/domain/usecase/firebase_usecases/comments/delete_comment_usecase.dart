import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class DeleteCommentUsecase {
  final FirebaseRepository repository;
  DeleteCommentUsecase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.deleteComment(comment);
  }
}
