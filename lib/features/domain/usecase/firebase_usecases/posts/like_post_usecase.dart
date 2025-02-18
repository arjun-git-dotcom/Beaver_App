import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class LikePostUsecase {
  final FirebaseRepository repository;
  LikePostUsecase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.likePost(post);
  }
}
