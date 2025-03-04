import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class FollowUsecase {
  final FirebaseRepository repository;
  FollowUsecase({required this.repository});

  Future<void> call(UserEntity user) async {
    return  repository.followUser(user);
  }
}
