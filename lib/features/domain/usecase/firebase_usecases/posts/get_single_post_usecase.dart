import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class GetSinglePostUsecase {
  final FirebaseRepository repository;

  GetSinglePostUsecase({required this.repository});

 Stream<List<PostEntity>> call(String  postId) {
    return repository.getSinglePost(postId);
  }
}
