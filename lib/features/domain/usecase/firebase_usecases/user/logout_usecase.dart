
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class LogoutUsecase{
  final FirebaseRepository repository;
  LogoutUsecase({required this.repository});

  Future<void> call() {
    return repository.logOut();
  }
}
