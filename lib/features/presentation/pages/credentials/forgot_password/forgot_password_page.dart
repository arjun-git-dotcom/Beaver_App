import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/presentation/widgets/bottom_container_widget.dart';
import 'package:social_media/features/presentation/widgets/form_container_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController emailController;

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Enter your email and we will sent the password to your email',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            sizeVer(10),
            FormContainerWidget(
              controller: emailController,
              labelText: "Enter your email",
              hintText: "Enter your email",
            ),
            sizeVer(10),
            BottomContainerWidget(
                text: "Reset Password",
                color: blueColor,
                onTapListener: () => resetPassword())
          ],
        ),
      ),
    );
  }

  Future resetPassword() async {
    try {
      String email = emailController.text.trim();

      var userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        toast('User not found');
      }
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      toast('email sent successfully');
    } on FirebaseException {
      toast('Please double check your email');
    }
  }
}
