import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class ReadReplyUsecase {
  final FirebaseRepository firebaseRepository;
  ReadReplyUsecase({required this.firebaseRepository});

  Stream<List<ReplyEntity>> call(ReplyEntity reply)  {
    return firebaseRepository.readReply(reply);
  }
}