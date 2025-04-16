import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/presentation/cubit/form/form_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/user_cubit.dart';
import 'package:social_media/features/presentation/pages/profile/widget/profile_form_widget.dart';
import 'package:social_media/features/widget_profile.dart';

class EditProfilepage extends StatefulWidget {
  final UserEntity currentUser;

  const EditProfilepage({super.key, required this.currentUser});

  @override
  State<EditProfilepage> createState() => _EditProfilepageState();
}

class _EditProfilepageState extends State<EditProfilepage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(text: widget.currentUser.username ?? '');
    _emailController = TextEditingController(text: widget.currentUser.email ?? '');
    _bioController = TextEditingController(text: widget.currentUser.bio ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void updateUserProfile() async {
    setState(() => _isUpdating = true);

    await BlocProvider.of<UserCubit>(context).updateUser(
      UserEntity(
        uid: widget.currentUser.uid,
        username: _usernameController.text,
        email: _emailController.text,
        bio: _bioController.text,
      ),
    );

    _clear();
  }

  void _clear() {
    context.read<FormCubit>().resetForm();
    _usernameController.clear();
    _emailController.clear();
    _bioController.clear();

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: _isUpdating ? null : updateUserProfile,
              child: Icon(
                Icons.done,
                color: _isUpdating ? Colors.grey : Colors.blue,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            profileWidget(imageUrl: widget.currentUser.profileUrl),
            sizeVer(15),
            const Text(
              'Change Profile Picture',
              style: TextStyle(color: blueColor, fontSize: 15),
            ),
            sizeVer(50),
            ProfileFormWidget(
              title: 'Username',
              controller: _usernameController,
            ),
            ProfileFormWidget(
              title: 'Email',
              controller: _emailController,
            ),
            ProfileFormWidget(
              title: 'Bio',
              controller: _bioController,
            ),
            sizeVer(20),
            if (_isUpdating)
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Text('Updating...'),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ),
            sizeVer(20),
          ],
        ),
      ),
    );
  }
}
