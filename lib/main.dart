import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/follow_unfollow_user_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_users_usecase.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/update_user_usecase.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_state.dart';
import 'package:social_media/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/user_cubit.dart';
import 'package:social_media/features/presentation/pages/credentials/login.dart';
import 'package:social_media/features/presentation/pages/main_screen/main_screen.dart';
import 'package:social_media/on_generate_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media/injection_container.dart' as di;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await di.init();




  di.printRegisteredDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
 

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) {
          print('1 2 3 4 5 h e l l o');
          return di.sl<UserCubit>();
        }),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Beaver',
        onGenerateRoute: OnGenerateRoute.route,
        initialRoute: '/',
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
              if (authState is Authenticated) {
                return MainScreen(
                  uid: authState.uid,
                );
              } else {
                return const LoginPage();
              }
            });
          }
        },
      ),
    );
  }
}
