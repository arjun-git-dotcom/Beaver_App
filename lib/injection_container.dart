import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/cloudinary/cloudinary_data_source._impl.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/cloudinary/cloudinary_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/comment_remote_data_source/comment_remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/credential_remote_data_source/credential_remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/post_remote_data_souce/post_remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/reply_remote_data_source/reply_remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/user_remote_data_source/user_remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources_impl/comment_remote_data_source_impl/comment_remote_data_source_impl.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources_impl/credential_remote_data_source_impl/credential_remote_data_source_impl.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources_impl/post_remote_data_source_impl/post_remote_data_source_impl.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources_impl/reply_remote_data_source_impl/reply_remote_data_source_impl.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources_impl/user_remote_data_source_impl/user_remote_source_impl.dart';
import 'package:social_media/features/data/repository/firebase_repository_impl.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/comments/create_comment_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/comments/delete_comment_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/comments/like_comment_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/comments/read_comment_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/comments/update_comment_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/likepage/likepage_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/create_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/delete_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/get_single_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/like_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/read_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/save_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/update_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/replys/create_reply_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/replys/delete_reply_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/replys/like_reply_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/replys/read_reply_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/replys/update_reply_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/savedposts/read_savedPost_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/storage/upload_image_to_storage.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/create_user_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/follow_unfollow_user_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_current_uuid_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_users_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/google_signin_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/is_login_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/login_user_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/logout_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/register_user_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/update_user_usecase.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:social_media/features/presentation/cubit/bookmark/bookmark_cubit.dart';
import 'package:social_media/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:social_media/features/presentation/cubit/comment_flag/comment_update.dart';
import 'package:social_media/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:social_media/features/presentation/cubit/current_uid/current_uid_cubit.dart';
import 'package:social_media/features/presentation/cubit/form/form_cubit.dart';
import 'package:social_media/features/presentation/cubit/image/image_cubit.dart';
import 'package:social_media/features/presentation/cubit/index/index.dart';
import 'package:social_media/features/presentation/cubit/like_animation/like_animation_cubit.dart';
import 'package:social_media/features/presentation/cubit/obscure_text/obscure_text_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/get_single_post/get_single_post_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/cubit/replys/reply_cubit.dart';
import 'package:social_media/features/presentation/cubit/savedposts/savedpost_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user_reply_flag/user_reply_flag_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External Dependencies
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);

  // Data Sources
  sl.registerLazySingleton<CloudinaryRepository>(() => CloudinaryRepositoryImpl(
      firebaseAuth: sl.call(), firebaseFirestore: sl.call()));

  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteSourceImpl(
      firebaseAuth: sl.call(), firebaseFirestore: sl.call()));
  sl.registerLazySingleton<CredentialRemoteDataSource>(() =>
      CredentialRemoteDataSourceImpl(
          firebaseAuth: sl.call(),
          cloudinaryRepository: sl.call(),
          firebaseFirestore: sl.call()));

  sl.registerLazySingleton<PostRemoteDataSource>(() => PostRemoteDataSourceImpl(
      credentialRemoteDataSource: sl.call(), firebaseFirestore: sl.call()));

  sl.registerLazySingleton<CommentRemoteDataSource>(() =>
      CommentRemoteDataSourceImpl(
          firebaseFirestore: sl.call(), credentialRemoteDataSource: sl.call()));

  sl.registerLazySingleton<ReplyRemoteDataSource>(() =>
      ReplyRemoteDataSourceImpl(
          firebaseFirestore: sl.call(), credentialRemoteDataSource: sl.call()));


  // Repositories
  sl.registerLazySingleton<FirebaseRepository>(() => FirebaseRepositoryImpl(
    replyRemoteDataSource: sl.call(),
    postRemoteDataSource: sl.call(),
    commentRemoteDataSource: sl.call(),
    credentialRemoteDataSource: sl.call(),
    userRemoteDataSource: sl.call(),
   cloudinaryRepository: sl.call()));

  // Use Cases - User
  sl.registerLazySingleton<FollowUsecase>(() {
    return FollowUsecase(repository: sl.call());
  });
  sl.registerLazySingleton<GetUsersUsecase>(() {
    return GetUsersUsecase(repository: sl.call());
  });
  sl.registerLazySingleton<UpdateUserUsecase>(
      () => UpdateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(
      () => GoogleSignInUsecase(firebaseRepository: sl.call()));
  sl.registerLazySingleton(() => CreateuserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => LogoutUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => IsLoginUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUuidUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => LoginUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => RegisterUserUsecase(repository: sl.call()));

  // Use Cases - Posts
  sl.registerLazySingleton(() => CreatePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadPostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => LikePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSinglePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => SavePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadSavedpostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => LikepageUsecase(repository: sl.call()));

  //use Cases - comments

  sl.registerLazySingleton(() => CreateCommentUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCommentUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeCommentUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCommentUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadCommentUsecase(repository: sl.call()));

//Use Cases - replys

  sl.registerLazySingleton(() => CreateReplyUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReplyUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeReplyUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReplyUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadReplyUsecase(repository: sl.call()));

  // Use Cases - Storage
  sl.registerLazySingleton(
      () => UploadImageToStorageUsecase(repository: sl.call()));

  // Cubits
  sl.registerFactory(() => AuthCubit(
      logoutUsecase: sl.call(),
      isLoginUsecase: sl.call(),
      getCurrentUuidUsecase: sl.call(),
      googleSignInUsecase: sl.call()));

  sl.registerFactory(() => CredentialCubit(
        loginUserUsecase: sl.call(),
        registerUserUsecase: sl.call(),
      ));

  sl.registerFactory(() => UserCubit(
        followUsecase: sl<FollowUsecase>(),
        getUsersUsecase: sl<GetUsersUsecase>(),
        updateUserUsecase: sl<UpdateUserUsecase>(),
      ));

  sl.registerFactory(() => CommentCubit(
      createCommentUsecase: sl<CreateCommentUsecase>(),
      deleteCommentUsecase: sl<DeleteCommentUsecase>(),
      likeCommentUsecase: sl<LikeCommentUsecase>(),
      readCommentUsecase: sl<ReadCommentUsecase>(),
      updateCommentUsecase: sl<UpdateCommentUsecase>()));
  sl.registerFactory(() => GetSingleUserCubit(getSingleUserUsecase: sl.call()));
  sl.registerFactory(() => PostCubit(
      createPostUsecase: sl.call(),
      deletePostUsecase: sl.call(),
      updatePostUsecase: sl.call(),
      likePostUsecase: sl.call(),
      readPostUsecase: sl.call(),
      savePostUsecase: sl.call()));

  sl.registerFactory(() => ReplyCubit(
      createReplyUsecase: sl.call(),
      deleteReplyUsecase: sl.call(),
      likeReplyUsecase: sl.call(),
      readReplyUsecase: sl.call(),
      updateReplyUsecase: sl.call()));

  sl.registerFactory(() => GetSinglePostCubit(getSinglePostUsecase: sl.call()));

  sl.registerFactory(() => SavedpostCubit(
      readSavedpostUsecase: sl.call(), readPostUsecase: sl.call()));

  sl.registerFactory(() => ImageCubit());
  sl.registerFactory(() => FormCubit());
  sl.registerFactory(() => LikeAnimationCubit());
  sl.registerFactory(() => IndexCubit());
  sl.registerFactory(() => CommentflagCubit());
  sl.registerFactory(() => UserReplyFlagCubit());
  sl.registerFactory(() => CurrentUidCubit());
  sl.registerFactory(() => ObscureTextCubit());
  sl.registerFactory(() => BookmarkCubit());
}
