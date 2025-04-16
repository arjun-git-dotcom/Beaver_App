import 'package:flutter/material.dart';
import 'package:social_media/features/presentation/pages/video_call/videocall_page.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatPage extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;
  final String peerId;
  final String peerName;

  const ChatPage(
      {super.key,
      required this.currentUserId,
      required this.peerId,
      required this.peerName,
      required this.currentUserName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future<void> _connectFuture;

  @override
  void initState() {
    super.initState();

    _connectFuture = ZIMKit()
        .connectUser(
      id: widget.currentUserId,
      name: widget.currentUserName,
    )
        .then((_) {
      return ZIMKit().updateUserInfo(name: widget.currentUserName);
    });

   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peerName),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VideoCallPage()));
              },
              icon: const Icon(Icons.video_call))
        ], 
      ),
      body: FutureBuilder(
        future: _connectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to connect: ${snapshot.error}'));
          }

          return ZIMKitMessageListPage(
            conversationID: widget.peerId,
            conversationType: ZIMConversationType.peer,
          );
        },
      ),
    );
  }
}
