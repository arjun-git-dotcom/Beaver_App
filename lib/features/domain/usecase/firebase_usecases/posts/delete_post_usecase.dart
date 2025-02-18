import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class DeletePostUsecase {
  final FirebaseRepository repository;
  DeletePostUsecase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.deletePost(post);
  }
}
