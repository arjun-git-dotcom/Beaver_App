import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/presentation/pages/video_call/video_call_page.dart';
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
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();

    _connectFuture = ZIMKit()
        .connectUser(
      id: widget.currentUserId,
      name: widget.currentUserName,
    )
        .then((_) {
      ZIMKit().updateUserInfo(name: widget.currentUserName);
      setState(() {
        _isConnected = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:appbarColor,
        title: Text(widget.peerName),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VideoCallPage()));
              },
              icon: const Icon(Icons.video_call)),
        ],
      ),
      body: _isConnected
          ? ZIMKitMessageListPage(
              conversationID: widget.peerId,
              conversationType: ZIMConversationType.peer,
              messageContentBuilder: (context, message, defaultWidget) {
                final isMe = message.info.senderUserID == widget.currentUserId;
                final timestamp = message.info.timestamp;
                final formattedDate = DateFormat('EEEE, hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(timestamp),
                );

                return Stack(
  clipBehavior: Clip.none,
  children: [
   
    Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue[200] : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 220),
        child: Text(
          message.textContent?.text ?? '',
          style: const TextStyle(fontSize: 16),
          
          softWrap: true,
        ),
      ),
    ),
    
    Positioned(
      bottom: 0,
      left: isMe ? null : 8,
      right: isMe ? 8 : null,
      child: Text(
        formattedDate,
        style: const TextStyle(fontSize: 10, color: primaryColor),
      ),
    ),
  ],
);

              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
