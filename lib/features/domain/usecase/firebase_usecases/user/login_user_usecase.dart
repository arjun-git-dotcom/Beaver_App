
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class LoginUserUsecase{
  final FirebaseRepository repository;
  LoginUserUsecase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.loginUser(user);
  }
}
