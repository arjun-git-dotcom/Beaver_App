import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class UpdatePostUsecase {
  final FirebaseRepository repository;
  UpdatePostUsecase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.updatePost(post);
  }
}
