import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';

class AppEntity {
  UserEntity? userEntity;
  PostEntity? postEntity;
  String? postId;
  String? creatorUid;
  AppEntity({this.userEntity, this.postEntity, this.postId, this.creatorUid});
}
