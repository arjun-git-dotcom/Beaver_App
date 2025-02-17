import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/presentation/cubit/user/user_cubit.dart';
import 'package:social_media/features/presentation/pages/profile/widget/profile_form_widget.dart';
import 'package:social_media/features/widget_profile.dart';

class EditProfilepage extends StatefulWidget {
  final UserEntity currentUser;
  const EditProfilepage({required this.currentUser, super.key});

  @override
  State<EditProfilepage> createState() => _EditProfilepageState();
}

class _EditProfilepageState extends State<EditProfilepage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _websiteController;
  late TextEditingController _bioController;
   _isUpdating = false;
  @override
  void initState() {
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _websiteController = TextEditingController();
    _bioController = TextEditingController();

    super.initState();
  }

  @override
  dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _websiteController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  updateUserProfile() {
    BlocProvider.of<UserCubit>(context).updateUser(UserEntity(
        uid: widget.currentUser.uid,
        username: _usernameController.text,
        name: _nameController.text,
        website: _websiteController.text,
        bio: _bioController.text)).then(_clear());
  }


_clear(){
  setState(() {
     _isUpdating=false;
  _usernameController.clear();
  _nameController.clear();
  _bioController.clear();
  _websiteController.clear();
    
  });
  Navigator.pop(context);
 

}
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
        actions:  [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => updateUserProfile(),
              child:const  Icon(
                Icons.done,
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            profileWidget(imageUrl: widget.currentUser.profileUrl),
            sizeVer(15),
            const Text(
              'Change Profile Picture',
              style: TextStyle(color: blueColor, fontSize: 15),
            ),
            sizeVer(100),
            ProfileFormWidget(
              title: 'Name',
              controller: _nameController,
            ),
            ProfileFormWidget(
              title: 'username',
              controller: _usernameController,
            ),
            ProfileFormWidget(
              title: 'website',
              controller: _websiteController,
            ),
            ProfileFormWidget(
              title: 'bio',
              controller: _bioController,
            ),
            sizeVer(10),
            _isUpdating==true? Row(children: [const Text('Please wait ..'), sizeHor(10),  const CircularProgressIndicator()],):const SizedBox(height: 0,width: 0,)

            
          ],
        ),
      ),
    );
  }
}
