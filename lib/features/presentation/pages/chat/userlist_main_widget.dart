import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_current_uuid_usecase.dart';
import 'package:social_media/features/presentation/cubit/user/user_cubit.dart';
import 'package:social_media/features/presentation/cubit/user/user_state.dart';

class UsersListMainWidget extends StatefulWidget {
  final GetCurrentUuidUsecase getCurrentUuidUsecase;
  const UsersListMainWidget({required this.getCurrentUuidUsecase, super.key});

  @override
  State<UsersListMainWidget> createState() => _UsersListMainWidgetState();
}

class _UsersListMainWidgetState extends State<UsersListMainWidget> {
  String? uid;

  Future<String?> getuid() async {
    uid = await widget.getCurrentUuidUsecase.call();
    return uid;
  }

  @override
  void initState() {
    getuid();
    context.read<UserCubit>().getUsers(user: UserEntity(uid: uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final currentUser = state.users
                .where((userDoc) => userDoc.uid == uid)
                .toList()
                .first;
            final users =
                state.users.where((userDoc) => userDoc.uid != uid).toList();

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.username ?? 'No Name'),
                  subtitle: Text(user.email ?? ''),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PageConstants.chatPage,
                      arguments: {
                        'currentUserId': uid,
                        'peerId': user.uid,
                        "peerName": user.username,
                        "currentUserName":currentUser.username
                      },
                    );
                  },
                );
              },
            );
          } else if (state is UserFailure) {
            return const Center(child: Text("Failed to load users."));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
