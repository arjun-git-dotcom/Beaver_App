import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class CreateCommentUsecase {
  final FirebaseRepository repository;
  CreateCommentUsecase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.createComment(comment);
  }
}
