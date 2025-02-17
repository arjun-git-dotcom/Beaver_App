import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:social_media/features/widget_profile.dart';

class Profilepage extends StatefulWidget {
  final UserEntity currentUser;
  const Profilepage({required this.currentUser,super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
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
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    InkWell(
                        onTap: () => _openbottomModelSheet(context,widget.currentUser),
                        child: Icon(MdiIcons.menu))
                  ],
                ),
                sizeVer(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     profileWidget(imageUrl: widget.currentUser.profileUrl),
                    Row(
                      children: [
                         Column(
                          children: [Text('${widget.currentUser.totalPosts}'), const Text('Posts')],
                        ),
                        sizeHor(20),
                         Column(
                          children: [Text('${widget.currentUser.totalFollowers}'), const Text('followers')],
                        ),
                        sizeHor(20),
                         Column(
                          children: [Text('${widget.currentUser.totalFollowing}'), const Text('following')],
                        )
                      ],
                    )
                  ],
                ),
                sizeVer(10),
                 Text('${widget.currentUser.name  ==""  ? widget.currentUser.username:widget.currentUser.name }',
                    style:
                       const  TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                 Text(
                 ' ${widget.currentUser.bio}',
                  style: const TextStyle(fontSize: 12),
                ),
                sizeVer(10),
                GridView.builder(
                    itemCount: 15,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return Container(
                        height: 30,
                        width: 30,
                        color: secondaryColor,
                      );
                    })
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure ?'),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: () async {
                          BlocProvider.of<AuthCubit>(context).logOut();
                          Navigator.pushNamedAndRemoveUntil(context,
                              PageConstants.loginpage, (route) => false);
                          await GoogleSignIn().signOut();
                          FirebaseAuth.instance.signOut();
                        },
                        child: const Text('Yes')),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'))
                  ],
                )
              ],
            ),
          ));
}

_openbottomModelSheet(context,currentUser) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 180,
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
                      context, PageConstants.editProfilepage,arguments: currentUser),
                  child: const Text('Edit profile')),
              sizeVer(10),
              const Divider(
                color: secondaryColor,
              ),
              const Text('Saved Posts'),
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
