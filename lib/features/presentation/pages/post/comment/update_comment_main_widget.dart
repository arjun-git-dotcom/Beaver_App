import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:social_media/features/presentation/cubit/comment_flag/comment_update.dart';
import 'package:social_media/features/presentation/pages/profile/widget/profile_form_widget.dart';
import 'package:social_media/features/presentation/widgets/bottom_container_widget.dart';

class UpdateCommentMainWidget extends StatefulWidget {
  final CommentEntity comment;
  const UpdateCommentMainWidget({required this.comment, super.key});

  @override
  State<UpdateCommentMainWidget> createState() =>
      _UpdateCommentMainWidgetState();
}

class _UpdateCommentMainWidgetState extends State<UpdateCommentMainWidget> {
  TextEditingController? _descriptionController;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.comment.description);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ProfileFormWidget(
              title: "Comment",
              controller: _descriptionController,
            ),
            sizeVer(10),
            BottomContainerWidget(
              color: blueColor,
              text: "Save Changes",
              onTapListener: () {
                _updateComment();
              },
            )
          ],
        ),
      ),
    );
  }

  _updateComment() {
    context.read<CommentflagCubit>().setCommentUpdate();

    BlocProvider.of<CommentCubit>(context)
        .updateComment(CommentEntity(
            postId: widget.comment.postId,
            commentId: widget.comment.commentId,
            description: _descriptionController!.text))
        .then((value) {
      context.read<CommentflagCubit>().resetCommentUpdate();
      _descriptionController!.clear();

      Navigator.pop(context);
    });
  }
}
