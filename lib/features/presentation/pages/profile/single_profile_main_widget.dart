import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_current_uuid_usecase.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:social_media/features/presentation/cubit/current_uid/current_uid_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_state.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_state.dart';
import 'package:social_media/features/presentation/cubit/user/user_cubit.dart';
import 'package:social_media/features/presentation/widgets/bottom_container_widget.dart';

import 'package:social_media/features/presentation/widgets/widget_profile.dart';
import 'package:social_media/injection_container.dart' as di;

class SingleProfileMainWidget extends StatefulWidget {
  final String otherUserId;
  const SingleProfileMainWidget({required this.otherUserId, super.key});

  @override
  State<SingleProfileMainWidget> createState() =>
      _SingleProfileMainWidgetState();
}

class _SingleProfileMainWidgetState extends State<SingleProfileMainWidget> {
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.otherUserId);
    BlocProvider.of<PostCubit>(context).getPost(post: const PostEntity());
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      context.read<CurrentUidCubit>().setUid(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = context.watch<CurrentUidCubit>().state;
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, singleuserstate) {
        if (singleuserstate is GetSingleUserLoaded) {
          final singleuser = singleuserstate.user;
          return Scaffold(
            appBar: AppBar(),
            body: SizedBox(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${singleuser.username}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            currentUid == singleuser.uid
                                ? InkWell(
                                    onTap: () => _openbottomModelSheet(
                                        context, singleuser),
                                    child: Icon(MdiIcons.menu))
                                : const SizedBox.shrink()
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
                                      imageUrl: singleuser.profileUrl)),
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text('${singleuser.totalPosts}'),
                                    const Text('Posts')
                                  ],
                                ),
                                sizeHor(20),
                                Column(
                                  children: [
                                    Text('${singleuser.totalFollowers}'),
                                    const Text('followers')
                                  ],
                                ),
                                sizeHor(20),
                                Column(
                                  children: [
                                    Text('${singleuser.totalFollowing}'),
                                    const Text('following')
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        sizeVer(10),
                        Text(
                            '${singleuser.name == "" ? singleuser.username : singleuser.name}',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        Text(
                          ' ${singleuser.bio}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        sizeVer(10),
                        currentUid == singleuser.uid
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                              )
                            : BottomContainerWidget(
                                text: singleuser.followers!.contains(currentUid)
                                    ? "UnFollow"
                                    : "Follow",
                                color:
                                    singleuser.followers!.contains(currentUid)
                                        ? secondaryColor.withOpacity(.4)
                                        : blueColor,
                                onTapListener: () {
                                  BlocProvider.of<UserCubit>(context)
                                      .followUser(
                                          user: UserEntity(
                                              uid: currentUid,
                                              otheruid: widget.otherUserId));
                                },
                              ),
                        sizeVer(10),
                        BlocBuilder<PostCubit, PostState>(
                          builder: (context, poststate) {
                            if (poststate is PostLoaded) {
                              final posts = poststate.posts
                                  .where((post) =>
                                      post.creatorUid == widget.otherUserId)
                                  .toList();
                              if (posts.isEmpty) {
                                return const Padding(
                                  padding:  EdgeInsets.all(20.0),
                                  child:  Center(
                                    child: Text("No Posts Yet",style: TextStyle(color: blueColor),),
                                  ),
                                );
                              }
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
                            return SpinkitConstants()
                                .spinKitRotatingCircle(blueColor);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return SpinkitConstants().spinkitcircle(blueColor);
      },
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
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
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
_openbottomModelSheet(BuildContext context, UserEntity currentUser) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    backgroundColor: backgroundColor,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'More Options',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 25),

            ListTile(
              leading: const Icon(Icons.info_outline, color: blueColor),
              title: const Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, PageConstants.aboutPage, arguments: currentUser);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              hoverColor: Colors.blue.shade50,
            ),

            const Divider(color: secondaryColor, height: 20),

            ListTile(
              leading: const Icon(Icons.edit, color: blueColor),
              title: const Text(
                'Edit Profile',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, PageConstants.editProfilepage, arguments: currentUser);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              hoverColor: Colors.blue.shade50,
            ),

            const Divider(color: secondaryColor, height: 20),

            ListTile(
              leading: const Icon(Icons.bookmark_outline, color: blueColor),
              title: const Text(
                'Saved Posts',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, PageConstants.savedPostpage);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              hoverColor: Colors.blue.shade50,
            ),

            const Divider(color: secondaryColor, height: 20),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                await logOut(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              hoverColor: Colors.red.shade50,
            ),

            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

