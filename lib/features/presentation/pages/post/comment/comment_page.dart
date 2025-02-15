import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/presentation/widgets/form_container_widget.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  bool _isUserReplaying = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back)),
        title: const Text('Comments'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              const CircleAvatar(),
              sizeHor(10),
              const Text('Arjun Krishnaraj')
            ],
          ),
          const Text('Hello World'),
          sizeVer(10),
          const Divider(),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(),
                                      sizeHor(10),
                                      const Text('Karnan')
                                    ],
                                  ),
                                  Icon(MdiIcons.heartOutline)
                                ],
                              ),
                              const Text('Good Post'),
                              Row(
                                children: [
                                  const Text(
                                    '30/01/25',
                                    style: TextStyle(
                                        color: darkgreyColor, fontSize: 12),
                                  ),
                                  sizeHor(10),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isUserReplaying = !_isUserReplaying;
                                      });
                                    },
                                    child: const Text(
                                      'reply',
                                      style: TextStyle(
                                          color: darkgreyColor, fontSize: 12),
                                    ),
                                  ),
                                  sizeHor(10),
                                  const Text(
                                    'View Replys',
                                    style: TextStyle(
                                        color: darkgreyColor, fontSize: 12),
                                  )
                                ],
                              ),
                              _isUserReplaying == true
                                  ? sizeVer(10)
                                  : sizeVer(0),
                              _isUserReplaying == true
                                  ? Column(
                                      children: [
                                        const FormContainerWidget(
                                          hintText: 'Post your reply....',
                                        ),
                                        sizeVer(10),
                                        const Text(
                                          'Post',
                                          style: TextStyle(color: blueColor),
                                        )
                                      ],
                                    )
                                  : const SizedBox(
                                      height: 0,
                                      width: 0,
                                    )
                            ],
                          )),
                    ),
                  ]),
            ),
          ),
          _commentSection(),
        ]),
      ),
    );
  }

  _commentSection() {
    return Container(
      color: darkgreyColor,
      width: double.infinity,
      height: 55,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: backgroundColor,
            ),
          ),
          sizeHor(10),
          const Expanded(
              child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Post your comment...',
                hintStyle: TextStyle(color: secondaryColor)),
          )),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Post',
              style: TextStyle(color: blueColor),
            ),
          )
        ],
      ),
    );
  }
}
