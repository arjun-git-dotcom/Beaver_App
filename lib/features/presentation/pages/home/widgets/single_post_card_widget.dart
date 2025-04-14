import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/app_entity.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_current_uuid_usecase.dart';
import 'package:social_media/features/presentation/cubit/bookmark/bookmark_cubit.dart';
import 'package:social_media/features/presentation/cubit/like_animation/like_animation_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/pages/post/widget/like_animation_widget.dart';
import 'package:social_media/features/widget_profile.dart';
import 'package:social_media/injection_container.dart' as di;

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;

  const SinglePostCardWidget({required this.post, super.key});

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  late Future<String> _currentUid;
  int count = 0;

  @override
  void initState() {
    _currentUid = di.sl<GetCurrentUuidUsecase>().call();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _currentUid,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentUid = snapshot.data!;
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
                        onTap: () =>
                            _openbottomModelSheet(context, widget.post),
                        child: Icon(MdiIcons.dotsVertical),
                      ),
                    ],
                  ),
                  sizeVer(10),
                  GestureDetector(
                    onTap: () =>
                        displayImage(widget.post.postImageUrl, context),
                    onDoubleTap: () {
                      _likePost();
                      
                      context
                          .read<LikeAnimationCubit>()
                          .startAnimation(widget.post.postId!);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child:
                              profileWidget(imageUrl: widget.post.postImageUrl),
                        ),
                        BlocBuilder<LikeAnimationCubit, Map<String, bool>>(
                          builder: (context, state) {
                            final isAnimating =
                                state[widget.post.postId!] ?? false;

                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isAnimating ? 1 : 0,
                              child: LikeAnimationWidget(
                                duration: const Duration(milliseconds: 300),
                                isLikeAnimating: isAnimating,
                                onLikeFinish: () {
                                  context
                                      .read<LikeAnimationCubit>()
                                      .resetAnimation(widget.post.postId!);
                                },
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 100,
                                ),
                              ),
                            );
                          },
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
                          widget.post.likes!.contains(currentUid)
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
                            onTap: () => Navigator.pushNamed(
                                context, 'commentPage',
                                arguments: AppEntity(
                                    creatorUid: currentUid,
                                    postId: widget.post.postId)),
                            child: Icon(MdiIcons.commentOutline,
                                color: primaryColor),
                          ),
                        ],
                      ),
                      BlocBuilder<BookmarkCubit, Set<String>>(
                        builder: (context, bookmarkedPosts) {
                          final isBookmarked =
                              bookmarkedPosts.contains(widget.post.postId);

                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<BookmarkCubit>()
                                  .toggleBookmark(widget.post.postId!);
                              BlocProvider.of<PostCubit>(context)
                                  .savePostUsecase(
                                      widget.post.postId!, currentUid);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            },
                            child: Icon(
                              Icons.bookmark,
                              color:
                                  isBookmarked ? primaryColor : secondaryColor,
                            ),
                          );
                        },
                      )
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
        });
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

  _openbottomModelSheet(context, PostEntity post) {
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
                    onTap: () => Navigator.pushNamed(context, 'updatePostPage',
                        arguments: post),
                    child: const Text('Update Post')),
                sizeVer(10),
                const Divider(
                  color: secondaryColor,
                ),
                GestureDetector(
                    onTap: () {
                      _deletePost();
                    },
                    child: const Text('Delete Posts')),
                sizeVer(10),
              ],
            ),
          );
        });
  }

  _deletePost() {
    BlocProvider.of<PostCubit>(context)
        .deletePost(post: PostEntity(postId: widget.post.postId));
  }
}
