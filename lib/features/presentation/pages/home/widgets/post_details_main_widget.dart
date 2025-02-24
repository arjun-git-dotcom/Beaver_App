import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_current_uuid_usecase.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_state.dart';
import 'package:social_media/features/presentation/pages/home/widgets/like_animation_widget.dart';
import 'package:social_media/features/widget_profile.dart';
import 'package:social_media/injection_container.dart' as di;

class PostDetailsMainWidget extends StatefulWidget {
  final PostEntity post;

  const PostDetailsMainWidget({required this.post, super.key});

  @override
  State<PostDetailsMainWidget> createState() => _PostDetailsMainWidgetState();
}

class _PostDetailsMainWidgetState extends State<PostDetailsMainWidget> {
  bool isLikeAnimating = false;
  String _currentUid = "";
  @override
  void initState() {
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      _currentUid = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit,PostState>(
      builder: (context, postdetailstate) {
        return Container(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: profileWidget(
                                  imageUrl: widget.post.userProfileUrl)),
                        ),
                        sizeHor(10),
                        Text(widget.post.username!),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _openbottomModelSheet(context),
                      child: Icon(MdiIcons.dotsVertical),
                    ),
                  ],
                ),
                sizeVer(10),
                GestureDetector(
                  onTap: () => displayImage(widget.post.postImageUrl, context),
                  onDoubleTap: () {
                    _likePost();
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child:
                            profileWidget(imageUrl: widget.post.postImageUrl),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimationWidget(
                          duration: const Duration(milliseconds: 300),
                          isLikeAnimating: isLikeAnimating,
                          onLikeFinish: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sizeVer(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        widget.post.likes!.contains(_currentUid)
                            ? GestureDetector(
                                onTap: () => _likePost(),
                                child: Icon(
                                  MdiIcons.heart,
                                  color: Colors.red,
                                ),
                              )
                            : GestureDetector(
                                onTap: () => _likePost(),
                                child: Icon(MdiIcons.heartOutline,
                                    color: primaryColor)),
                        sizeHor(10),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, 'commentPage'),
                          child: Icon(MdiIcons.commentOutline,
                              color: primaryColor),
                        ),
                      ],
                    ),
                    const Icon(Icons.bookmark_border),
                  ],
                ),
                Text(
                  '${widget.post.totalLikes!} likes',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    Text(
                      ' ${widget.post.username!}',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    sizeHor(10),
                    Text(widget.post.description!),
                  ],
                ),
                Text('view all ${widget.post.totalComments} comments'),
                Text(
                  DateFormat("dd/MMM/yyyy")
                      .format(widget.post.createAt!.toDate()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _likePost() {
    BlocProvider.of<PostCubit>(context)
        .likePost(post: PostEntity(postId: widget.post.postId));
  }

  displayImage(image, context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                color: Colors.transparent,
                child: profileWidget(imageUrl: image),
              ));
        });
  }
}

_openbottomModelSheet(context) {
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
                  onTap: () => Navigator.pushNamed(context, 'updatePostPage'),
                  child: const Text('Update Post')),
              sizeVer(10),
              const Divider(
                color: secondaryColor,
              ),
              const Text('Delete Posts'),
              sizeVer(10),
            ],
          ),
        );
      });
}
