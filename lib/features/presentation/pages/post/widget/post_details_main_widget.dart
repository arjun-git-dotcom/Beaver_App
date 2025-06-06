import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_current_uuid_usecase.dart';
import 'package:social_media/features/presentation/cubit/bookmark/bookmark_cubit.dart';
import 'package:social_media/features/presentation/cubit/like_animation/like_animation_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/get_single_post/get_single_post_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/get_single_post/get_single_post_state.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/pages/post/widget/like_animation_widget.dart';
import 'package:social_media/features/presentation/widgets/widget_profile.dart';
import 'package:social_media/injection_container.dart' as di;

class PostDetailsMainWidget extends StatefulWidget {
  final String postId;
  const PostDetailsMainWidget({required this.postId, super.key});

  @override
  State<PostDetailsMainWidget> createState() => _PostDetailsMainWidgetState();
}

class _PostDetailsMainWidgetState extends State<PostDetailsMainWidget> {
  late Future<String> _currentUid;
  @override
  void initState() {
    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.postId);

    _currentUid=di.sl<GetCurrentUuidUsecase>().call();
    super.initState();
  }

  void _likePost() {
    BlocProvider.of<PostCubit>(context)
        .likePost(post: PostEntity(postId: widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text("Post Details",style: AppTextStyle.stylishfont(color:primaryColor),)),
      body: BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
        builder: (context, singlePostState) {
          if (singlePostState is GetSinglePostLoaded) {
            final singlepost = singlePostState.post;
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                          imageUrl: singlepost.userProfileUrl)),
                                ),
                                sizeHor(10),
                                Text(singlepost.username!),
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
                          onTap: () =>
                              displayImage(singlepost.postImageUrl, context),
                          onDoubleTap: () {
                            _likePost();
                            context
                                .read<LikeAnimationCubit>()
                                .startAnimation(widget.postId);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: profileWidget(
                                    imageUrl: singlepost.postImageUrl),
                              ),
                              BlocBuilder<LikeAnimationCubit, Map<String, bool>>(
                                builder: (context, state) {
                                  final isAnimating = state[widget.postId] ?? false;
                
                                  return AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: isAnimating ? 1 : 0,
                                    child: LikeAnimationWidget(
                                      duration: const Duration(milliseconds: 300),
                                      isLikeAnimating: isAnimating,
                                      onLikeFinish: () {
                                        context
                                            .read<LikeAnimationCubit>()
                                            .resetAnimation(widget.postId);
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
                                singlepost.likes!.contains(currentUid)
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
                             BlocBuilder<BookmarkCubit, Set<String>>(
                        builder: (context, bookmarkedPosts) {
                          final isBookmarked =
                              bookmarkedPosts.contains(widget.postId);

                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<BookmarkCubit>()
                                  .toggleBookmark(widget.postId);
                              BlocProvider.of<PostCubit>(context)
                                  .savePostUsecase(
                                      widget.postId, currentUid);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            },
                            child: 
                            isBookmarked?const Icon(Icons.bookmark,color: secondaryColor,):const Icon(
                              Icons.bookmark_outline,
                              color:
                                  primaryColor
                            )
                          );
                        },
                      )
                          ],
                        ),
                        Text(
                          '${singlepost.totalLikes!} likes',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            Text(
                              ' ${singlepost.username!}',
                              style: const TextStyle(fontWeight: FontWeight.w900),
                            ),
                            sizeHor(10),
                            Text(singlepost.description!),
                          ],
                        ),
                        Text('view all ${singlepost.totalComments} comments'),
                        Text(
                          DateFormat("dd/MMM/yyyy")
                              .format(singlepost.createAt!.toDate()),
                        ),
                      ],
                    ),
                  ),
                );
              }
            );
          } else {
            return SpinkitConstants().spinkitspinninglines(blueColor);
          }
        },
      ),
    );
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
