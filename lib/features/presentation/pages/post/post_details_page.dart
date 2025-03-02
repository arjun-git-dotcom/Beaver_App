import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/presentation/cubit/posts/get_single_post/get_single_post_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/pages/post/widget/post_details_main_widget.dart';
import "package:social_media/injection_container.dart" as di;

class PostDetailsPage extends StatelessWidget {
  final String postId;
  const PostDetailsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetSinglePostCubit>(
          create: (context) => di.sl<GetSinglePostCubit>(),
        ),
        BlocProvider<PostCubit>(create: (context) => di.sl<PostCubit>())
      ],
      child:  PostDetailsMainWidget(postId: postId),
    );
  }
}
