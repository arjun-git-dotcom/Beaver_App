import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class CreateReplyUsecase {
  final FirebaseRepository firebaseRepository;
  CreateReplyUsecase({required this.firebaseRepository});

  Future<void> call(ReplyEntity reply) async {
    firebaseRepository.createReply(reply);
  }
}
