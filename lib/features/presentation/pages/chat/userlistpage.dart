import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_current_uuid_usecase.dart';
import 'package:social_media/features/presentation/cubit/user/user_cubit.dart';

import 'package:social_media/features/presentation/pages/chat/userlist_main_widget.dart';
import 'package:social_media/injection_container.dart' as di;

class Userlistpage extends StatelessWidget {
  const Userlistpage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>di.sl<UserCubit>(),
      child: UsersListMainWidget(getCurrentUuidUsecase: di.sl<GetCurrentUuidUsecase>()));
  }
}