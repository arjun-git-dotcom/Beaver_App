import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:social_media/features/presentation/pages/post/comment/update_comment_main_widget.dart';
import 'package:social_media/injection_container.dart' as di;
class UpdateCommentPage extends StatelessWidget {
  final CommentEntity comment;
  const UpdateCommentPage({required this.comment,super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentCubit>(create: (context)=>di.sl<CommentCubit>(),child: UpdateCommentMainWidget(comment:comment ),);
  }
}