import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_source_impl.dart';
import 'package:social_media/features/data/repository/firebase_repository_impl.dart';
import 'package:social_media/features/domain/repository/firebase_repository.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/storage/upload_image_to_storage.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/create_user_usecase.dart';
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
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/user_cubit.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //Cubits
  sl.registerFactory(() => AuthCubit(
      logoutUsecase: sl.call(),
      isLoginUsecase: sl.call(),
      getCurrentUuidUsecase: sl.call(),
      googleSignInUsecase: sl.call()));

  sl.registerFactory(() => CredentialCubit(
        loginUserUsecase: sl.call(),
        registerUserUsecase: sl.call(),
      ));

  sl.registerFactory(() =>
      UserCubit(getUsersUsecase: sl.call(), updateUserUsecase: sl.call()));

  sl.registerFactory(() => GetSingleUserCubit(getSingleUserUsecase: sl.call()));

  //usecases

  sl.registerLazySingleton(() => LogoutUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => IsLoginUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUuidUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => LoginUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => RegisterUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateuserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GoogleSignInUsecase(firebaseRepository: sl.call()));


  //cloud storage
  
  sl.registerLazySingleton(() => UploadImageToStorageUsecase(repository: sl.call()));

  //repositories

  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(firebaseRemoteDataSource: sl.call()));

  //Remote Data Source

  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(
          firebaseFirestore: sl.call(), firebaseAuth: sl.call()));

  //externals

  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
}
