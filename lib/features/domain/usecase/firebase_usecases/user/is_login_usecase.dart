
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class IsLoginUsecase {
  final FirebaseRepository repository;
  IsLoginUsecase({required this.repository});

  Future<bool> call() {
    return repository.islogin();
  }
}
