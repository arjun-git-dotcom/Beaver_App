import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class LikepageUsecase {
  final FirebaseRepository repository;
  LikepageUsecase({required this.repository});

  Future<List<PostEntity>> call(String currentUserId) async {
    return repository.likepage();
  }
}
