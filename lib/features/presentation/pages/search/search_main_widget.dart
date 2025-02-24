import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_state.dart';
import 'package:social_media/features/presentation/pages/search/search_widget.dart';
import 'package:social_media/features/widget_profile.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({super.key});

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  late TextEditingController searchcontroller;

  @override
  void initState() {
    searchcontroller = TextEditingController();
    BlocProvider.of<PostCubit>(context).getPost(post: const PostEntity());
    super.initState();
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SearchWidget(controller: searchcontroller),
                sizeVer(10),
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, postState) {
                    if (postState is PostLoaded) {
                      final posts = postState.posts;
                      return GridView.builder(
                          itemCount: posts.length,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  crossAxisCount: 3),
                                  
                          itemBuilder: (context, index) {
                            return SizedBox(
                                height: 30,
                                width: 30,
                                child: profileWidget(
                                    imageUrl: posts[index].postImageUrl));
                          });
                    }
                    return Center(
                        child:
                            SpinkitConstants().spinkitspinninglines(blueColor));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
