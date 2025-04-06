import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class DeleteReplyUsecase {
  final FirebaseRepository repository;
  DeleteReplyUsecase({required this.repository});

  Future<void> call(ReplyEntity reply) async {
    repository.deleteReply(reply);
  }
}