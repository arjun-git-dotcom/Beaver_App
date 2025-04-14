import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_current_uuid_usecase.dart';
import 'package:social_media/features/presentation/cubit/replys/reply_cubit.dart';
import 'package:social_media/features/presentation/cubit/replys/reply_state.dart';
import 'package:social_media/features/presentation/cubit/user_reply_flag/user_reply_flag_cubit.dart';
import 'package:social_media/features/presentation/pages/post/comment/widgets/single_reply_widget.dart';
import 'package:social_media/features/presentation/widgets/form_container_widget.dart';
import 'package:social_media/features/widget_profile.dart';
import 'package:social_media/injection_container.dart' as di;
import 'package:uuid/uuid.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback onLongPress;
  final VoidCallback onLikeListener;
  final UserEntity currentUser;
  const SingleCommentWidget(
      {required this.onLikeListener,
      required this.onLongPress,
      required this.comment,
      required this.currentUser,
      super.key});

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  String _currentUid = "";
  TextEditingController? _replyDescriptionController;

  @override
  void initState() {
    BlocProvider.of<ReplyCubit>(context).readReply(
        reply: ReplyEntity(
            postId: widget.comment.postId,
            commentId: widget.comment.commentId));
    _replyDescriptionController = TextEditingController();
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      _currentUid = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double replypadding =
        (MediaQuery.of(context).size.width * 0.15).clamp(40, 80);

    final replyCubit = context.watch<UserReplyFlagCubit>();
    final isReplying = replyCubit.isReplyingTo(widget.comment.commentId!);

    print("reply is ${isReplying}");
    return InkWell(
      onLongPress: widget.onLongPress,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: profileWidget(imageUrl: widget.comment.profileUrl),
                  ),
                ),
                sizeHor(10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.comment.username!),
                              InkWell(
                                  onTap: () => widget.onLikeListener(),
                                  child: Icon(
                                      widget.comment.likes!
                                              .contains(_currentUid)
                                          ? MdiIcons.heart
                                          : MdiIcons.heartOutline,
                                      color: widget.comment.likes!
                                              .contains(_currentUid)
                                          ? redColor
                                          : primaryColor))
                            ],
                          ),
                          Text(widget.comment.description!),
                          Row(
                            children: [
                              Text(
                                DateFormat("dd/MMM/yyyy")
                                    .format(widget.comment.createdAt!.toDate()),
                                style: const TextStyle(
                                    color: darkgreyColor, fontSize: 12),
                              ),
                              sizeHor(10),
                              GestureDetector(
                                onTap: () {
                                  final cubit =
                                      context.read<UserReplyFlagCubit>();
                                  if (cubit.isReplyingTo(
                                      widget.comment.commentId!)) {
                                    cubit.stopReplying();
                                  } else {
                                    cubit.startReplyingTo(
                                        widget.comment.commentId!);
                                  }

                                  print(isReplying);
                                },
                                child: Text("Reply"),
                              ),
                              sizeHor(10),
                              InkWell(
                                onTap: () =>
                                    BlocProvider.of<ReplyCubit>(context)
                                        .readReply(
                                            reply: ReplyEntity(
                                                postId: widget.comment.postId,
                                                commentId:
                                                    widget.comment.commentId)),
                                child: const Text(
                                  'View Replys',
                                  style: TextStyle(
                                      color: darkgreyColor, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: replypadding),
              child: BlocBuilder<ReplyCubit, ReplyState>(
                builder: (BuildContext context, replystate) {
                  if (replystate is ReplySuccess) {
                    print(replystate.reply.length);
                    final replys = replystate.reply
                    .where((element) {
                      print('where is ${element.commentId}');
                      return element.commentId == widget.comment.commentId;
                    }).toList();
                    print("the filteredd replies are ${replys}");
                    print("THE COMMENTiD IS${widget.comment.commentId}");
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: replys.length,
                        itemBuilder: (context, index) =>
                            SingleReplyWidget(reply: replys[index]));
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
            isReplying ? sizeVer(10) : sizeVer(0),
            isReplying
                ? Column(
                    children: [
                      FormContainerWidget(
                        hintText: 'Post your reply....',
                        controller: _replyDescriptionController,
                      ),
                      sizeVer(10),
                      GestureDetector(
                        onTap: () => _createReply(),
                        child: const Text(
                          'Post',
                          style: TextStyle(color: blueColor),
                        ),
                      )
                    ],
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }

  _createReply() {
    BlocProvider.of<ReplyCubit>(context)
        .createReply(
            reply: ReplyEntity(
                replyId: Uuid().v1(),
                commentId: widget.comment.commentId,
                postId: widget.comment.postId,
                userId: widget.currentUser.uid,
                username: widget.currentUser.name,
                profileUrl: widget.currentUser.profileUrl,
                description: _replyDescriptionController!.text,
                createdAt: Timestamp.now(),
                likes: []))
        .then((value) => _clear());
  }

  _clear() {
    _replyDescriptionController!.clear();
    context.read<UserReplyFlagCubit>().stopReplying();
  }
}
