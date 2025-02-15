import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';


class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          "assets/beaver-image.svg",
          height: 80,
          width: 50,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(MdiIcons.facebookMessenger),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: darkgreyColor,
                      ),
                      sizeHor(10),
                      const Text('username'),
                    ],
                  ),
                  GestureDetector(
                  
                    onTap: ()=> _openbottomModelSheet(context),
                    child: Icon(MdiIcons.dotsVertical))
                ],
              ),
              sizeVer(10),
              Container(
                  color: darkgreyColor,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3),
              sizeVer(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(MdiIcons.heartOutline, color: primaryColor),
                      sizeHor(10),
                      GestureDetector(
          onTap: ()=>Navigator.pushNamed(context, 'commentPage'),                      child: Icon(
                          MdiIcons.commentOutline,
                          color: primaryColor,
                        ),
                      )
                    ],
                  ),
                  const Icon(Icons.bookmark_border)
                ],
              ),
              const Text('0 likes',style: TextStyle(fontWeight: FontWeight.w700),),
              Row(
                children: [
                 const  Text(
                    'username',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  sizeHor(10),
                  const Text('some description')
                ],
              ),
              const Text('view all 10 comments'),
              const Text('24-01-25')
            ],
          ),
        ),
      ),
    );
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
              const Text('More Options',style: TextStyle(fontWeight: FontWeight.w700),),
              sizeVer(10),
              const Divider(color: secondaryColor,),
              GestureDetector(
                onTap: ()=>Navigator.pushNamed(context, 'updatePostPage'),
                child: const Text('Update Post')),
               sizeVer(10),
                 const Divider(color: secondaryColor,),
              const Text('Delete Posts'),
               sizeVer(10),
              
            ],
          ),
        );
      });
}