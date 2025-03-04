import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/cloudinary/cloudinary_data_source._impl.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/cloudinary/cloudinary_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_source_impl.dart';
import 'package:social_media/features/data/repository/firebase_repository_impl.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/create_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/delete_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/get_single_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/like_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/read_post_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/posts/update_post_usecase.dart';
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
import 'package:social_media/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/get_single_post/get_single_post_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/user_cubit.dart';


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

  sl.registerLazySingleton<FirebaseRemoteDataSource>(
      () => FirebaseRemoteDataSourceImpl(
            cloudinaryRepository: sl.call(),
            firebaseFirestore: sl.call(),
            firebaseAuth: sl.call(),
          ));

  // Repositories
  sl.registerLazySingleton<FirebaseRepository>(() => FirebaseRepositoryImpl(
      firebaseRemoteDataSource: sl.call(), cloudinaryRepository: sl.call()));

  // Use Cases - User
  sl.registerLazySingleton<FollowUsecase>(() {
    return FollowUsecase(repository: sl.call());
  });
  sl.registerLazySingleton<GetUsersUsecase>(() {
    return GetUsersUsecase(repository: sl.call());
  });
  sl.registerLazySingleton<UpdateUserUsecase>(() => UpdateUserUsecase(repository: sl.call()));
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

  sl.registerFactory(() => GetSingleUserCubit(getSingleUserUsecase: sl.call()));
  sl.registerFactory(() => PostCubit(
        createPostUsecase: sl.call(),
        deletePostUsecase: sl.call(),
        updatePostUsecase: sl.call(),
        likePostUsecase: sl.call(),
        readPostUsecase: sl.call(),
      ));

  sl.registerFactory(() => GetSinglePostCubit(getSinglePostUsecase: sl.call()));
  
}
