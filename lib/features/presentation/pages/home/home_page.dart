import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_state.dart';
import 'package:social_media/features/presentation/pages/home/widgets/home_appbar_widget.dart';
import 'package:social_media/features/presentation/pages/home/widgets/single_post_card_widget.dart';
import 'package:social_media/injection_container.dart' as di;

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
        appBar: const HomeAppbarWidget(),
        body:
        
         BlocProvider<PostCubit>(
          create: (context) =>
              di.sl<PostCubit>()..getPost(post: const PostEntity()),
          child:
              BlocBuilder<PostCubit, PostState>(builder: (context, poststate) {
            if (poststate is PostLoading) {
              return Center(
                  child: SpinkitConstants().spinkitspinninglines(blueColor));
            }

            if (poststate is PostFailure) {
              toast('Some failure occured while creating the post',duration: Toast.LENGTH_SHORT);
            }
            if (poststate is PostLoaded) {
              return poststate.posts.isEmpty
                  ? _noPostsYetWwidget()
                  : ListView.builder(
                      itemCount: poststate.posts.length,
                      itemBuilder: (context, index) {
                        final post = poststate.posts[index];
                        return BlocProvider<PostCubit>(
                            create: (context) => di.sl<PostCubit>(),
                            child: SinglePostCardWidget(post: post));
                      });
            }

            return SpinkitConstants().spinkitspinninglines(primaryColor);
          }),
        ));
  }

  _noPostsYetWwidget() {
    return const Center(
        child: Text(
      'No Posts Yet',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ));
  }
}
