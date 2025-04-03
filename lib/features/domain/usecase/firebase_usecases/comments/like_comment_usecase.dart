import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class LikeCommentUsecase {
  final FirebaseRepository repository;
  LikeCommentUsecase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.likeComment(comment);
  }
}
