import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';

class HomeAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
     backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [appbarColor, themeColor],
              stops: [0.4,0.7],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,))),
          title: SvgPicture.asset(
            "assets/beaver-image.svg",
            height: 80,
            width: 50,
            
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, PageConstants.userListPage);
                  },
                  child: Icon(MdiIcons.chat)),
            )
          ],
        );
  }
  
  @override
  
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
}