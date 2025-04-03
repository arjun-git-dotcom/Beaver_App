
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class SavePostUsecase {
  final FirebaseRepository repository;
  SavePostUsecase({required this.repository});

  Future<void> call(String  postId,String userId) {
    return repository.savePost(postId,userId);
  }
}
