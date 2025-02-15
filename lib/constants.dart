import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const backgroundColor = Colors.white;
const blueColor = Colors.blue;
const primaryColor = Colors.black;
const secondaryColor = Colors.grey;
const darkgreyColor = Color.fromARGB(255, 92, 92, 92);

Widget sizeVer(double height) {
  return SizedBox(
    height: height,
  );
}

Widget sizeHor(double width) {
  return SizedBox(
    width: width,
  );
}

class PageConstants {
  static const String editProfilepage = 'editProfilePage';
  static const String updatePostpage = 'updatePostPage';
  static const String commentpage = 'commentPage';
  static const String loginpage = 'loginPage';
  static const String registerpage = 'registerPage';
  static const String forgotPasswordPage= 'forgotPasswordPage';
}

class FirebaseConstants {
  static const String users = 'users';
  static const String posts = 'posts';
  static const String comment = 'comment';
  static const String reply = 'reply';
}

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: primaryColor,
      textColor: backgroundColor,
      fontSize: 16);
}
