import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';

import 'package:social_media/features/presentation/cubit/comment_flag/comment_update.dart';
import 'package:social_media/features/presentation/cubit/replys/reply_cubit.dart';
import 'package:social_media/features/presentation/pages/profile/widget/profile_form_widget.dart';
import 'package:social_media/features/presentation/widgets/bottom_container_widget.dart';

class UpdateReplyMainWidget extends StatefulWidget {
  final ReplyEntity reply;
  const UpdateReplyMainWidget({required this.reply, super.key});

  @override
  State<UpdateReplyMainWidget> createState() =>
      _UpdateReplyMainWidgetState();
}

class _UpdateReplyMainWidgetState extends State<UpdateReplyMainWidget> {
  TextEditingController? _descriptionController;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.reply.description);
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
        title: const Text('Edit Reply'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ProfileFormWidget(
              title: "Reply",
              controller: _descriptionController,
            ),
            sizeVer(10),
            BottomContainerWidget(
              color: blueColor,
              text: "Save Changes",
              onTapListener: () {
                _updateReply();
              },
            )
          ],
        ),
      ),
    );
  }

  _updateReply() {
    context.read<CommentflagCubit>().setCommentUpdate();

    BlocProvider.of<ReplyCubit>(context)
        .updateReply(reply:ReplyEntity(
            postId: widget.reply.postId,
            commentId: widget.reply.commentId,
            replyId: widget.reply.replyId,
            description: _descriptionController!.text))
        .then((value) {
      context.read<CommentflagCubit>().resetCommentUpdate();
      _descriptionController!.clear();

      Navigator.pop(context);
    });
  }
}
