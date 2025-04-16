import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_state.dart';
import 'package:social_media/features/presentation/cubit/user/user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/user_state.dart';
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
    BlocProvider.of<UserCubit>(context).getUsers(user: const UserEntity());

    searchcontroller.addListener(() {
      setState(() {});
    });
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
        child: Column(children: [
          SearchWidget(controller: searchcontroller),
          sizeVer(10),
          searchcontroller.text.isNotEmpty
              ? BlocBuilder<UserCubit, UserState>(
                  builder: (context, userstate) {
                    print('$userstate');
                    if (userstate is UserLoaded) {
                      final filter = userstate.users
                          .where((user) =>
                              user.username!
                                  .startsWith(searchcontroller.text) ||
                              user.username!.toLowerCase().startsWith(
                                  searchcontroller.text.toLowerCase()))
                          .toList();
                      return Column(mainAxisSize: MainAxisSize.min, children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filter.length,
                              itemBuilder: (context, index) {
                                final user = filter[index];

                                return GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, PageConstants.singleprofilePage,
                                      arguments: user.uid),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                            child: profileWidget(
                                                imageUrl: user.profileUrl)),
                                      ),
                                      sizeHor(10),
                                      Text(user.username!)
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ]);
                    }
                    return const CircularProgressIndicator();
                  },
                )
              : BlocBuilder<PostCubit, PostState>(
                  builder: (context, postState) {
                    if (postState is PostLoaded) {
                      final posts = postState.posts;
                      return Expanded(
                        child: GridView.builder(
                            itemCount: posts.length,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, PageConstants.postDetailsPage,
                                    arguments: posts[index].postId),
                                child: profileWidget(
                                    imageUrl: posts[index].postImageUrl),
                              );
                            }),
                      );
                    }
                    return Center(
                        child:
                            SpinkitConstants().spinkitspinninglines(blueColor));
                  },
                )
        ]),
      )),
    );
  }
}
