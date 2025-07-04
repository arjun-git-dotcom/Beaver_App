import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_current_uuid_usecase.dart';
import 'package:social_media/features/presentation/cubit/current_uid/current_uid_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_state.dart';
import 'package:social_media/features/presentation/widgets/widget_profile.dart';
import 'package:social_media/injection_container.dart' as di;
class LikedpageMainWidget extends StatefulWidget {
  const LikedpageMainWidget({super.key});

  @override
  State<LikedpageMainWidget> createState() => _LikedpageMainWidgetState();
}

class _LikedpageMainWidgetState extends State<LikedpageMainWidget> {
  @override
  void initState() {
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      context.read<CurrentUidCubit>().setUid(value);
      BlocProvider.of<PostCubit>(context).getLikedPosts(userId: value);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      appBar:AppBar(
        backgroundColor: appbarColor,
        centerTitle: true,
      title: const  Text(
        'Liked Posts',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),actions: [ Padding(
        padding: const EdgeInsets.only(right: 15),
        child: SvgPicture.asset(
            "assets/beaver-image.svg",
            height: 50, 
          ),
      ),
      ],
      
      
     
    
    
    ),
    
      body: Column(
        children: [
          BlocBuilder<PostCubit, PostState>(
            builder: (context, poststate) {
              if (poststate is PostLoaded) {
                final posts = poststate.posts;
                
                if (posts.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        "You haven't liked any posts yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }
                
                return Expanded(
                  child: GridView.builder(
                    itemCount: posts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      crossAxisCount: 3
                    ),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context, 
                        PageConstants.postDetailsPage,
                        arguments: posts[index].postId
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: profileWidget(imageUrl: posts[index].postImageUrl),
                      ),
                    )
                  ),
                );
              }
              
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}