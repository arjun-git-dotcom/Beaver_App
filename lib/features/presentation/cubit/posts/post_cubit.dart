import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/create_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/delete_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/like_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/read_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/save_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/update_post_usecase.dart';
import 'package:social_media/features/presentation/cubit/posts/post_state.dart';

class PostCubit extends Cubit<PostState> {
  final CreatePostUsecase createPostUsecase;
  final DeletePostUsecase deletePostUsecase;
  final UpdatePostUsecase updatePostUsecase;
  final LikePostUsecase likePostUsecase;
  final ReadPostUsecase readPostUsecase;
  final SavePostUsecase savePostUsecase;
  StreamSubscription<List<PostEntity>>? _postSubscription;
  PostCubit(
      {required this.createPostUsecase,
      required this.deletePostUsecase,
      required this.updatePostUsecase,
      required this.likePostUsecase,
      required this.readPostUsecase,
      required this.savePostUsecase})
      : super(PostInitial());



Future<void> getPost({required PostEntity post}) async {

  await _postSubscription?.cancel();
  
  emit(PostLoading());

  try {
    final streamResponse = readPostUsecase.call(post);
    _postSubscription = streamResponse.listen(
      (posts) {
        if (!isClosed) {
          emit(PostLoaded(posts: posts));
        }
      },
      onError: (error) {
        if (!isClosed) {
          if (error is SocketException) {
            emit(PostFailure());
          } else {
            emit(PostFailure());
          }
        }
      },
    );
  } catch (_) {
    if (!isClosed) {
      emit(PostFailure());
    }
  }
}


@override
Future<void> close() {
  _postSubscription?.cancel();
  return super.close();
}

  Future<void> updatePost({required PostEntity post}) async {
    try {
      await updatePostUsecase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> createPost({required PostEntity post}) async {
    try {
      await createPostUsecase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> likePost({required PostEntity post}) async {
    try {
      await likePostUsecase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> deletePost({required PostEntity post}) async {
    try {
      await deletePostUsecase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> savePost({required String postId,required String userId}) async {
    try {
      await savePostUsecase.call(postId,userId);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> getLikedPosts({required String userId}) async {
  await _postSubscription?.cancel();
  
  emit(PostLoading());

  try {
    final streamResponse = readPostUsecase.call(const PostEntity());
    _postSubscription = streamResponse.map((posts) {
      // Filter to only include posts liked by the current user
      return posts.where((post) => 
        post.likes != null && post.likes!.contains(userId)
      ).toList();
    }).listen(
      (likedPosts) {
        if (!isClosed) {
          emit(PostLoaded(posts: likedPosts));
        }
      },
      onError: (error) {
        if (!isClosed) {
          if (error is SocketException) {
            emit(PostFailure());
          } else {
            emit(PostFailure());
          }
        }
      },
    );
  } catch (_) {
    if (!isClosed) {
      emit(PostFailure());
    }
  }
}
}
