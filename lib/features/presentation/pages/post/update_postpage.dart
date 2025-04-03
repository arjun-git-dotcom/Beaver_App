import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/pages/post/widget/update_post_main_widget.dart';
import 'package:social_media/injection_container.dart' as di;
class UpdatePostpage extends StatelessWidget {
  final PostEntity post;
  const UpdatePostpage({required this.post,super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(create:(context)=>di.sl<PostCubit>(),
    
    child: UpdatePostMainWidget(post: post));
  }
}
