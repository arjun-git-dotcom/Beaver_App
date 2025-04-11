import 'package:social_media/features/domain/repository/firebase_repository.dart';

class CallUserUsecase {
  final FirebaseRepository firebaseRepository;
  CallUserUsecase({required this.firebaseRepository});

  Future<void> call(receiverToken, callerName, callID) {
    return firebaseRepository.callUser(receiverToken, callerName, callID);
  }
}
