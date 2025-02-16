import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class CreateUserWithImageUsecase {
  final FirebaseRepository repository;
  CreateUserWithImageUsecase({required this.repository});

  Future<void> call(UserEntity user,String profileUrl) {
    return repository.createUseWithImageUseCase(user,profileUrl);
  }
}
