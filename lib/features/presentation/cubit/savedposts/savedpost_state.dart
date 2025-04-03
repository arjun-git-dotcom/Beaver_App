import 'package:equatable/equatable.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/savedposts/savedposts_entity.dart';

abstract class SavedpostState extends Equatable{}


class SavedPostInitial extends SavedpostState {
  @override
  List<Object?> get props => [];
}

class  SavedPostLoading extends SavedpostState {
  @override
  List<Object?> get props => [];
}

class  SavedPostLoaded extends SavedpostState {
  final List<PostEntity> posts;

   SavedPostLoaded({required this.posts});
  @override
  List<Object?> get props => [posts];
}

class  SavedPostFailure extends SavedpostState {
  @override
  List<Object?> get props => [];
}
