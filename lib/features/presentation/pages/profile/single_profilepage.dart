import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social_media/features/presentation/pages/profile/single_profile_main_widget.dart';
import "package:social_media/injection_container.dart" as di;

class SingleProfilepage extends StatelessWidget {
  final String otheruserId;
  const SingleProfilepage({required this.otheruserId, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di.sl<GetSingleUserCubit>())
        ],
        child: SingleProfileMainWidget(
          otherUserId: otheruserId,
        ));
  }
}
