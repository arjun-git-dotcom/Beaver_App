import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/features/presentation/cubit/index/index.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/get_single_user/get_single_user_state.dart';
import 'package:social_media/features/presentation/pages/Liked_posts/liked_posts_page.dart';
import 'package:social_media/features/presentation/pages/home/home_page.dart';
import 'package:social_media/features/presentation/pages/post/upload_post_page.dart';
import 'package:social_media/features/presentation/pages/profile/profilepage.dart';
import 'package:social_media/features/presentation/pages/search/search_page.dart';

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
    context.read<IndexCubit>().changeIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    _currentIndex = context.watch<IndexCubit>().state;
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
        if (getSingleUserState is GetSingleUserLoaded) {
          final currentUser = getSingleUserState.user;
          bool isWebLayout = MediaQuery.of(context).size.width > 900;
          if (isWebLayout) {
            return Scaffold(
             
              body: Row(
                children: [
                  Container(
                    width: 72,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      color: backgroundColor,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                       
                        const Divider(),
                        _buildNavItem(Icons.home, 0),
                        _buildNavItem(Icons.search, 1),
                        _buildNavItem(Icons.add_circle, 2),
                        _buildNavItem(MdiIcons.heart, 3),
                        _buildNavItem(Icons.person_2_rounded, 4),
                      ],
                    ),
                  ),
             
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: pageController,
                            onPageChanged: onPageChanged,
                            children: [
                              const Homepage(),
                              const Searchpage(),
                              UploadPostpage(
                                currentUser: currentUser,
                              ),
                              const Likedpage(),
                              Profilepage(currentuser: currentUser)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              height: 50,
            index: _currentIndex,
              color: appbarColor,
              animationDuration:const  Duration(milliseconds: 300),
              backgroundColor: backgroundColor,
              items: [
                const 
                   Icon(Icons.home),
                
               const Icon(Icons.search),
               
                  const Icon(Icons.add_circle),
                
                 Icon(MdiIcons.heart),
                
                    const  Icon(Icons.person_2_rounded),
              ],
              onTap: navigationTapped,
            ),
            body: Center(
              child: PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                children: [
                  const Homepage(),
                  const Searchpage(),
                  UploadPostpage(
                    currentUser: currentUser,
                  ),
                  const Likedpage(),
                  Profilepage(currentuser: currentUser)
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
              child: SpinkitConstants().spinKitRotatingCircle(appbarColor)),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => navigationTapped(index),
      child: SizedBox(
        height: 60,
        width: double.infinity,
        child: Center(
          child: Icon(
            icon,
            size: 28,
            color: isSelected ? blueColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}