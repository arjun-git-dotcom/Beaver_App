import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:social_media/features/presentation/cubit/auth/auth_state.dart';
import 'package:social_media/features/presentation/cubit/credential/credential_cubit.dart';
import 'package:social_media/features/presentation/cubit/credential/credential_state.dart';
import 'package:social_media/features/presentation/pages/main_screen/main_screen.dart';
import 'package:social_media/features/presentation/pages/profile/widget/profile_form_widget.dart';

import 'package:social_media/features/presentation/widgets/bottom_container_widget.dart';
import 'package:social_media/features/presentation/widgets/form_container_widget.dart';
import 'package:social_media/features/widget_profile.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isRegisteredUp = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
  }

  File? _image;
  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform
          .getImageFromSource(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          toast('no image has been selcted');
        }
      });
    } catch (e) {
      toast('some error occured $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: BlocConsumer<CredentialCubit, CredentialState>(
          builder: (context, credentialState) {
            if (credentialState is CredentialSuccess) {
              return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authstate) {
                if (authstate is Authenticated) {
                  return MainScreen(uid: authstate.uid);
                } else {
                  return _bodyWidget();
                }
              });
            }
            return _bodyWidget();
          },
          listener: (context, credentialState) {
            if (credentialState is CredentialSuccess) {
              BlocProvider.of<AuthCubit>(context).loggedIn();
            }
            if (credentialState is CredentialFailure) {
              toast('Invalid Email and Password');
            }
          },
        ));
  }

  void _registerUser() {
    setState(() {
      isRegisteredUp = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .register(
            user: UserEntity(
                email: _emailController.text.trim(),
                username: _usernameController.text,
                password: _passwordController.text.trim(),
                bio: _bioController.text,
                totalPosts: 0,
                totalFollowers: 0,
                totalFollowing: 0,
                followers: const [],
                following: const [],
                profileUrl: "",
                website: "",
                name: "",
                imageFile: _image,
                uid: ""))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _bioController.clear();
      isRegisteredUp = false;
    });
  }

  _bodyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/beaver-image.svg",
                  height: 80,
                  width: 80,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Stack(children: [
               CircleAvatar(
                  radius: 50,
                  backgroundColor: blueColor,
                  child: profileWidget(image: _image)),
              Positioned(
                  right: -8,
                  bottom: -5,
                  child: IconButton(
                      onPressed: () =>selectImage(),
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 30,
                      )))
            ]),
            sizeVer(10),
            FormContainerWidget(
              controller: _usernameController,
              hintText: 'Enter your username',
            ),
            sizeVer(10),
            FormContainerWidget(
              controller: _emailController,
              hintText: 'Enter your email',
            ),
            sizeVer(10),
            FormContainerWidget(
              controller: _passwordController,
              hintText: 'Enter your password',
            ),
            sizeVer(10),
            FormContainerWidget(
              controller: _bioController,
              hintText: 'Enter your bio',
            ),
            sizeVer(10),
            BottomContainerWidget(
              text: 'Register',
              color: blueColor,
              onTapListener: () => _registerUser(),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            const Divider(color: primaryColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'loginPage', (route) => false);
                  },
                  child: const Text(
                    ' Login',
                    style: TextStyle(color: blueColor),
                  ),
                ),
              ],
            ),
            sizeVer(10),
            isRegisteredUp == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Please wait ',
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400),
                      ),
                      sizeHor(10),
                      const CircularProgressIndicator()
                    ],
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  )
          ],
        ),
      ),
    );
  }
}
