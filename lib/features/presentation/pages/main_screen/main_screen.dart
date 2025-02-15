import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_media/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_state.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_state.dart';
import 'package:social_media/features/presentation/pages/Liked/likespage.dart';
import 'package:social_media/features/presentation/pages/home/homepage.dart';
import 'package:social_media/features/presentation/pages/post/upload_postpage.dart';
import 'package:social_media/features/presentation/pages/profile/profilepage.dart';
import 'package:social_media/features/presentation/pages/search/searchpage.dart';

class MainScreen extends StatefulWidget {
  final String uid;
  const MainScreen({required this.uid, super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();

    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
       
        if (getSingleUserState is GetSingleUserLoaded) {
           final currentUser = getSingleUserState.user;
          return Scaffold(
            bottomNavigationBar: CupertinoTabBar(
              currentIndex: _currentIndex,
              activeColor: blueColor,
              backgroundColor: backgroundColor,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                ),
                const BottomNavigationBarItem(icon: Icon(Icons.search)),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle),
                ),
                BottomNavigationBarItem(icon: Icon(MdiIcons.heart)),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.person_2_rounded)),
              ],
              onTap: navigationTapped,
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: [
                const Homepage(),
                const Searchpage(),
                const Postpage(),
                const Likespage(),
                Profilepage(
                  currentUser: currentUser,
                )
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
