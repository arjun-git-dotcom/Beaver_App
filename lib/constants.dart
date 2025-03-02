import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  static const String forgotPasswordPage = 'forgotPasswordPage';

  static const String postDetailsPage = "postDetailsPage";
  static const String profilePage = 'profilePage';
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

class CloudinaryConstants {
  static const uploadPreset = "preset-for-file-upload";
}

class SpinkitConstants {
  spinkitcircle() {
    return SpinKitChasingDots();
  }

  spinkitspinninglines(color) {
    return SpinKitSpinningLines(color: color);
  }

  spinKitRotatingCircle(color) {
    return SpinKitRotatingCircle(
      color: color,
    );
  }
}
