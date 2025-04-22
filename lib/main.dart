import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_state.dart';
import 'package:social_media/features/presentation/cubit/bookmark/bookmark_cubit.dart';
import 'package:social_media/features/presentation/cubit/comment_flag/comment_update.dart';
import 'package:social_media/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:social_media/features/presentation/cubit/current_uid/current_uid_cubit.dart';
import 'package:social_media/features/presentation/cubit/form/form_cubit.dart';
import 'package:social_media/features/presentation/cubit/image/image_cubit.dart';
import 'package:social_media/features/presentation/cubit/index/index.dart';
import 'package:social_media/features/presentation/cubit/like_animation/like_animation_cubit.dart';
import 'package:social_media/features/presentation/cubit/obscure_text/obscure_text_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user_reply_flag/user_reply_flag_cubit.dart';
import 'package:social_media/features/presentation/pages/credentials/login_page.dart';
import 'package:social_media/features/presentation/pages/main_screen/main_screen.dart';
import 'package:social_media/on_generate_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_media/injection_container.dart' as di;
import 'package:zego_zimkit/zego_zimkit.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await ZIMKit().init(
      appID: int.parse(dotenv.env['APP_ID']!),
      appSign: dotenv.env['APP_SIGN']!);

  await Firebase.initializeApp();
  await di.init();

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
          return di.sl<UserCubit>();
        }),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (_) => di.sl<ImageCubit>()),
        BlocProvider(create: (_) => di.sl<FormCubit>()),
        BlocProvider(create: (_) => di.sl<LikeAnimationCubit>()),
        BlocProvider(create: (_) => di.sl<IndexCubit>()),
        BlocProvider(create: (_) => di.sl<CommentflagCubit>()),
        BlocProvider(create: (_) => di.sl<UserReplyFlagCubit>()),
        BlocProvider(create: (_) => di.sl<CurrentUidCubit>()),
        BlocProvider(create: (_) => di.sl<ObscureTextCubit>()),
        BlocProvider(create: (_) => di.sl<BookmarkCubit>())
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
