
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class RegisterUserUsecase{
  final FirebaseRepository repository;
 RegisterUserUsecase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.registerUser(user);
  }
}
