import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class CreatePostUsecase {
  final FirebaseRepository repository;
  CreatePostUsecase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.createPost(post);
  }
}
