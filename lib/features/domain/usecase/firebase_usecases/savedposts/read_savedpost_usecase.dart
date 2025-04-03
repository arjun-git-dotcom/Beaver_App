import 'package:social_media/features/domain/entities/savedposts/savedposts_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/read_post_usecase.dart';

class ReadSavedpostUsecase {
  final FirebaseRepository repository;
  ReadSavedpostUsecase({required this.repository});

  Stream<List<SavedpostsEntity>> call(String userId) {
    return repository.readsavedPost(userId);
  }
}