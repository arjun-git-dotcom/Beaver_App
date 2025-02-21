import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_state.dart';
import 'package:social_media/features/presentation/pages/home/widgets/single_post_card_widget.dart';
import 'package:social_media/injection_container.dart' as di;

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SvgPicture.asset(
            "assets/beaver-image.svg",
            height: 80,
            width: 50,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(MdiIcons.facebookMessenger),
            )
          ],
        ),
        body: BlocProvider<PostCubit>(
          create: (context)=>di.sl<PostCubit>()..getPost(post: const PostEntity()),
          child: BlocBuilder<PostCubit, PostState>(builder: (context, poststate) {
            if (poststate is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            }
          
            if (poststate is PostFailure) {
              toast('Some failure occured while creating the post');
            }
            if (poststate is PostLoaded) {
              return ListView.builder(
                
                itemCount: poststate.posts.length,
                itemBuilder: (context, index) {
                
                final post = poststate.posts[index];
                return SinglePostCardWidget(post: post);
              });
            }
            return const Center(child: CircularProgressIndicator());
          }),
        ));
  }
}
