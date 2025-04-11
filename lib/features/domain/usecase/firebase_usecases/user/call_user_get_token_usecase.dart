import 'package:social_media/features/domain/repository/firebase_repository.dart';

class CallUserGetTokenUsecase {
  final FirebaseRepository firebaseRepository;
  CallUserGetTokenUsecase({required this.firebaseRepository});

  Future<String?> call() {
    return firebaseRepository.getfcmToken();
  }
}
