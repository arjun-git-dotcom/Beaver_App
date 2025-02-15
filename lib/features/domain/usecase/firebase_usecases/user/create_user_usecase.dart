import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class CreateuserUsecase {
  final FirebaseRepository repository;
  CreateuserUsecase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.createUser(user);
  }
}
