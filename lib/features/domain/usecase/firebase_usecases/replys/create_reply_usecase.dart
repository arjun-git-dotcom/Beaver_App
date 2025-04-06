import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class CreateReplyUsecase {
  final FirebaseRepository repository;
  CreateReplyUsecase({required this.repository});

  Future<void> call(ReplyEntity reply) async {
   repository.createReply(reply);
  }
}
