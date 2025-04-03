import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/app_entity.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/presentation/pages/credentials/forgot_password/forgot_password.dart';
import 'package:social_media/features/presentation/pages/credentials/login.dart';
import 'package:social_media/features/presentation/pages/credentials/register.dart';
import 'package:social_media/features/presentation/pages/post/comment/comment_page.dart';
import 'package:social_media/features/presentation/pages/post/comment/update_comment_page.dart';
import 'package:social_media/features/presentation/pages/post/update_page.dart';
import 'package:social_media/features/presentation/pages/post/post_details_page.dart';
import 'package:social_media/features/presentation/pages/profile/edit_profilepage.dart';
import 'package:social_media/features/presentation/pages/profile/single_profilepage.dart';
import 'package:social_media/features/presentation/savedpost/savedpost.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PageConstants.editProfilepage:
        {
          if (args is UserEntity) {
            return routeBuilder(EditProfilepage(currentUser: args));
          }
          return routeBuilder(const NoPageFound());
        }
      case PageConstants.updatePostpage:
        {
          if(args is PostEntity){
              return routeBuilder( UpdatePostPage(post: args));
          }
        
        }
      case PageConstants.commentpage:
        {
          if (args is AppEntity) {
            return routeBuilder(CommentPage(appEntity: args));
          }
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

      case PageConstants.postDetailsPage:
        {
          if (args is String) {
            return routeBuilder(PostDetailsPage(postId: args));
          }
          return routeBuilder(const NoPageFound());
        }

      case PageConstants.singleprofilePage:
        {
          if (args is String) {
            return routeBuilder(SingleProfilepage(otheruserId: args));
          }
        }

      case PageConstants.savedPostpage:
        {
          return routeBuilder(SavedPostpage());
        }

      case PageConstants.updateCommentPage:
        {
          if (args is CommentEntity) {
            return routeBuilder(UpdateCommentPage(comment:args));
          }
        }
    }
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Page Found'),
        centerTitle: true,
      ),
      body: const Text('No Page Found'),
    );
  }
}
