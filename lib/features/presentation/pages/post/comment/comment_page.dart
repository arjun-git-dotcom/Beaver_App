import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/entities/app_entity.dart';
import 'package:social_media/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social_media/features/presentation/pages/post/comment/widgets/comment_main_widget.dart';
import 'package:social_media/injection_container.dart' as di;

class CommentPage extends StatelessWidget {
  final AppEntity appEntity;
  const CommentPage({required this.appEntity,super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(
        create: (context) => di.sl<CommentCubit>(),
        
      ),BlocProvider(create: (context)=>di.sl<GetSingleUserCubit>())],
     child: CommentMainWidget(appEntity: appEntity),
    );
  }
}
