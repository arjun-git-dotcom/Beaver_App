import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/pages/Liked_posts/like_posts_page_main_widget.dart';

import 'package:social_media/injection_container.dart'as di;

class Likedpage extends StatelessWidget {
  const Likedpage({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
        providers: [
          BlocProvider<PostCubit>(
            create: (context) => di.sl<PostCubit>(),
          ),
        ],
        child:  const LikedpageMainWidget(
      
        ));
  }
}