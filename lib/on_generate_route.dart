import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/presentation/pages/credentials/forgot_password/forgot_password.dart';
import 'package:social_media/features/presentation/pages/credentials/login.dart';
import 'package:social_media/features/presentation/pages/credentials/register.dart';
import 'package:social_media/features/presentation/pages/map/map_page.dart';
import 'package:social_media/features/presentation/pages/post/comment/comment_page.dart';
import 'package:social_media/features/presentation/pages/post/comment/update_page.dart';
import 'package:social_media/features/presentation/pages/profile/edit_profilepage.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PageConstants.editProfilepage:
        {
          return routeBuilder(const EditProfilepage());
        }
      case PageConstants.updatePostpage:
        {
          return routeBuilder(const UpdatePostPage());
        }
      case PageConstants.commentpage:
        {
          return routeBuilder(const CommentPage());
        }
      case PageConstants.loginpage:
        {
          return routeBuilder(const LoginPage());
        }
      case PageConstants.registerpage:
        {
          return routeBuilder(const RegisterPage());
        }

      case PageConstants.forgotPasswordPage:
        {
          return routeBuilder(const ForgotPasswordPage());
        }
    }
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
