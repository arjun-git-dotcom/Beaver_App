import 'package:social_media/features/domain/entities/replys/replay_entity.dart';

abstract class ReplyRemoteDataSource {
 Future<void> createReply(ReplyEntity reply);
  Future<void> updateReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> readReply(ReplyEntity reply);
  Future<void> deleteReply(ReplyEntity reply);
  Future<void> likeReply(ReplyEntity reply);

}