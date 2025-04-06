import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class UpdateReplyUsecase {
  final FirebaseRepository repository;
  UpdateReplyUsecase({required this.repository});

  Future<void> call(ReplyEntity reply) async {
    repository.updateReply(reply);
  }
}