import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/app_entity.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:social_media/features/presentation/cubit/comment/comment_state.dart';
import 'package:social_media/features/presentation/cubit/replys/reply_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_state.dart';
import 'package:social_media/features/presentation/pages/post/comment/widgets/single_comment_widget.dart';
import 'package:social_media/features/widget_profile.dart';
import 'package:uuid/uuid.dart';
import 'package:social_media/injection_container.dart' as di;

class CommentMainWidget extends StatefulWidget {
  final AppEntity appEntity;
  const CommentMainWidget({required this.appEntity, super.key});

  @override
  State<CommentMainWidget> createState() => _CommentMainWidgetState();
}

class _CommentMainWidgetState extends State<CommentMainWidget> {
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.appEntity.creatorUid!);

    BlocProvider.of<CommentCubit>(context)
        .getComments(widget.appEntity.postId!);

    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back)),
          title: const Text('Comments'),
          centerTitle: true,
        ),
        body: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
          builder: (context, singleUserstate) {
            if (singleUserstate is GetSingleUserLoaded) {
              final singleUser = singleUserstate.user;
              return BlocBuilder<CommentCubit, CommentState>(
                  builder: (BuildContext context, commentState) {
                if (commentState is CommentSuccess) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: profileWidget(
                                      imageUrl: singleUser.password),
                                ),
                              ),
                              sizeHor(10),
                              Text('username')
                            ],
                          ),
                          const Text('Hello World'),
                          sizeVer(10),
                          const Divider(),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: commentState.comments.length,
                                  itemBuilder: (context, index) {
                                    final singleComment =
                                        commentState.comments[index];
                                    return BlocProvider<ReplyCubit>(
                                      create: (context)=>di.sl<ReplyCubit>(),
                                      child: SingleCommentWidget(
                                        currentUser: singleUser,
                                        onLikeListener: () {
                                          _likeComment(singleComment);
                                        },
                                        onLongPress: () {
                                          _openbottomModelSheet(
                                              context, singleComment);
                                        },
                                        comment: singleComment,
                                      ),
                                    );
                                  })),
                          _commentSection(currentUser: singleUser),
                        ]),
                  );
                }
                return const CircularProgressIndicator();
              });
            }
            return const CircularProgressIndicator();
          },
        ));
  }

  _commentSection({required UserEntity currentUser}) {
    return Container(
      color: darkgreyColor,
      width: double.infinity,
      height: 55,
      child: Row(
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: profileWidget(imageUrl: currentUser.profileUrl),
                ),
              )),
          sizeHor(10),
          Expanded(
              child: TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Post your comment...',
                hintStyle: TextStyle(color: secondaryColor)),
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _createComment(currentUser);
              },
              child: const Text(
                'Post',
                style: TextStyle(color: blueColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  _createComment(UserEntity currentUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(CommentEntity(
            userId: currentUser.uid,
            username: currentUser.username,
            profileUrl: currentUser.profileUrl,
            commentId: Uuid().v1(),
            description: descriptionController.text,
            postId: widget.appEntity.postId,
            createdAt: Timestamp.now(),
            likes: [],
            totalReplys: 0))
        .then((value) {
      setState(() {
        descriptionController.clear();
      });
    });
  }

  _openbottomModelSheet(context, CommentEntity comment) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            color: backgroundColor,
            child: Column(
              children: [
                sizeVer(10),
                const Text(
                  'More Options',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                sizeVer(10),
                const Divider(
                  color: secondaryColor,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, PageConstants.updateCommentPage,
                          arguments: comment);
                    },
                    child: const Text('Update comment')),
                sizeVer(10),
                const Divider(
                  color: secondaryColor,
                ),
                GestureDetector(
                    onTap: () =>
                        _deleteComment(comment.commentId!, comment.postId!),
                    child: const Text('Delete comment')),
                sizeVer(10),
              ],
            ),
          );
        });
  }

  _deleteComment(String commentId, String postId) {
    BlocProvider.of<CommentCubit>(context)
        .deleteComment(CommentEntity(commentId: commentId, postId: postId));
  }

  _likeComment(CommentEntity comment) {
    BlocProvider.of<CommentCubit>(context).likeCommments(
        CommentEntity(commentId: comment.commentId, postId: comment.postId));
  }

  
}
