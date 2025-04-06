import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class ReadReplyUsecase {
  final FirebaseRepository repository;
  ReadReplyUsecase({required this.repository});

  Stream<List<ReplyEntity>> call(ReplyEntity reply)  {
    return repository.readReply(reply);
  }
}