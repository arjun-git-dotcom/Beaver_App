import 'package:equatable/equatable.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoaded extends UserState {
 final List<UserEntity> users;

const  UserLoaded({required this.users});
  @override
  List<Object?> get props => [users];
}

class UserFailure extends UserState {
  @override
  List<Object?> get props => [];
}
