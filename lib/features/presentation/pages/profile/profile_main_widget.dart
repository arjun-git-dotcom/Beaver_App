import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_state.dart';
import 'package:social_media/features/presentation/widgets/widget_profile.dart';

class ProfileMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  
  const ProfileMainWidget({
    
    required this.currentUser, super.key});

  @override
  State<ProfileMainWidget> createState() => _ProfileMainWidgetState();
}

class _ProfileMainWidgetState extends State<ProfileMainWidget> {
  @override
  void initState() {
    BlocProvider.of<PostCubit>(context).getPost(post: const PostEntity());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.currentUser.username}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    InkWell(
                        onTap: () =>
                            _openbottomModelSheet(context, widget.currentUser),
                        child: Icon(MdiIcons.menu))
                  ],
                ),
                sizeVer(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: profileWidget(
                              imageUrl: widget.currentUser.profileUrl)),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text('${widget.currentUser.totalPosts}'),
                            const Text('Posts')
                          ],
                        ),
                        sizeHor(20),
                        Column(
                          children: [
                            GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, PageConstants.followersPage,
                                    arguments: widget.currentUser),
                                child: Text(
                                    '${widget.currentUser.totalFollowers}')),
                            const Text('followers')
                          ],
                        ),
                        sizeHor(20),
                        Column(
                          children: [
                            GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, PageConstants.followingPage,
                                    arguments: widget.currentUser),
                                child: Text(
                                    '${widget.currentUser.totalFollowing}')),
                            const Text('following')
                          ],
                        )
                      ],
                    )
                  ],
                ),
                sizeVer(10),
                Text(
                    '${widget.currentUser.name == "" ? widget.currentUser.username : widget.currentUser.name}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                Text(
                  ' ${widget.currentUser.bio}',
                  style: const TextStyle(fontSize: 12),
                ),
                sizeVer(10),
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, poststate) {
                    if (poststate is PostLoaded) {
                      final posts = poststate.posts
                          .where((post) =>
                              post.creatorUid == widget.currentUser.uid)
                          .toList();
                      return GridView.builder(
                          itemCount: posts.length,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 30,
                              width: 30,
                              child: profileWidget(
                                  imageUrl: posts[index].postImageUrl),
                            );
                          });
                    }
                    return const CircularProgressIndicator();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

logOut(context) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Log Out',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      content: const Text(
        'Are you sure you want to log out?',
        style: TextStyle(fontSize: 16),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () async {
            BlocProvider.of<AuthCubit>(context).logOut();
            Navigator.pushNamedAndRemoveUntil(
                context, PageConstants.loginpage, (route) => false);
          
          },
          child: const Text(
            'Log Out',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

_openbottomModelSheet(context, currentUser) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 220,
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
                  onTap: () => Navigator.pushNamed(
                      context, PageConstants.aboutPage,
                      arguments: currentUser),
                  child: const Text('About')),
              const Divider(
                color: secondaryColor,
              ),
              GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, PageConstants.editProfilepage,
                      arguments: currentUser),
                  child: const Text('Edit profile')),
              sizeVer(10),
              const Divider(
                color: secondaryColor,
              ),
              GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, PageConstants.savedPostpage),
                  child: const Text('Saved Posts')),
              sizeVer(10),
              const Divider(
                color: secondaryColor,
              ),
              InkWell(
                  onTap: () async {
                    logOut(context);
                  },
                  child: const Text('LogOut')),
            ],
          ),
        );
      });
}
