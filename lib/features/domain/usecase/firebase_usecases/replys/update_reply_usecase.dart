import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class UpdateReplyUsecase {
  final FirebaseRepository firebaseRepository;
  UpdateReplyUsecase({required this.firebaseRepository});

  Future<void> call(ReplyEntity reply) async {
    firebaseRepository.updateReply(reply);
  }
}