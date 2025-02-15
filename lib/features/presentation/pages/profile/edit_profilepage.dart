import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/presentation/pages/profile/widget/profile_form_widget.dart';

class EditProfilepage extends StatefulWidget {
  const EditProfilepage({super.key});

  @override
  State<EditProfilepage> createState() => _EditProfilepageState();
}

class _EditProfilepageState extends State<EditProfilepage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text('Edit Profile '),
        leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.done,
              color: Colors.blue,
            ),
          )
        ],
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            const CircleAvatar(radius: 80,backgroundColor: secondaryColor,),
            sizeVer(15),
            const Text('Change Profile Picture',style: TextStyle(color: blueColor,fontSize: 15),),
            sizeVer(100),
            const ProfileFormWidget(title: 'Name',),
           const  ProfileFormWidget(title: 'username',),
           const  ProfileFormWidget(title: 'website',),
            const ProfileFormWidget(title: 'bio',),
          ],
        ),
      ),
    );
  }
}
