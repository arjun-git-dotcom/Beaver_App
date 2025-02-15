import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class GetSingleUserUsecase {
  final FirebaseRepository repository;
  GetSingleUserUsecase({required this.repository});

  Stream<List<UserEntity>> call(String uuid) {
    return repository.getSingleUser(uuid);
  }
}
