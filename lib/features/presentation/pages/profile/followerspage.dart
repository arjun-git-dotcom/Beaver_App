
import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:social_media/features/presentation/widgets/widget_profile.dart';
import 'package:social_media/injection_container.dart' as di;

class Followerspage extends StatelessWidget {
  final UserEntity user;
  const Followerspage({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child:user.followers!.isEmpty
                            ? _noFollowersYetWidget()
                            : ListView.builder(
                itemCount: user.followers!.length,
                itemBuilder: (context, index) {
                  return StreamBuilder<List<UserEntity>>(
                      stream: di
                          .sl<GetSingleUserUsecase>()
                          .call(user.followers![index]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData == false) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.data!.isEmpty) {
                          return Container();
                        }
                        final singleuser = snapshot.data!.first;
                        return GestureDetector(
                          onTap: ()=>Navigator.pushNamed(context, PageConstants.singleprofilePage,arguments: singleuser.uid),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: profileWidget(imageUrl: singleuser.profileUrl)),
                              ),
                              sizeHor(10),
                               Text("${singleuser.username}"),
                            ],
                          ),
                        );
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
   _noFollowersYetWidget() {
    return  const Center(
      child: Text('No Followers',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
    );
  }
}
