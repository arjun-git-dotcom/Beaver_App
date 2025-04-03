import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_current_uuid_usecase.dart';
import 'package:social_media/features/presentation/widgets/form_container_widget.dart';
import 'package:social_media/features/widget_profile.dart';
import 'package:social_media/injection_container.dart' as di;
class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback onLongPress;
  final VoidCallback onLikeListener;
  const SingleCommentWidget(
      {required this.onLikeListener,required this.onLongPress, required this.comment, super.key});

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  bool _isUserReplaying = false;
   String _currentUid = "";
  @override
    void initState() {
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      _currentUid = value;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.onLongPress,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: widget.comment.profileUrl),
              ),
            ),
            sizeHor(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.comment.username!),
                          InkWell(
                            onTap: ()=>widget.onLikeListener(),
                            child: Icon(widget.comment.likes!.contains(_currentUid)?MdiIcons.heart:MdiIcons.heartOutline,color:widget.comment.likes!.contains(_currentUid)?redColor:primaryColor))
                        ],
                      ),
                      Text(widget.comment.description!),
                      Row(
                        children: [
                          Text(
                            DateFormat("dd/MMM/yyyy")
                                .format(widget.comment.createdAt!.toDate()),
                            style: const TextStyle(
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
                              style:
                                  TextStyle(color: darkgreyColor, fontSize: 12),
                            ),
                          ),
                          sizeHor(10),
                          const Text(
                            'View Replys',
                            style:
                                TextStyle(color: darkgreyColor, fontSize: 12),
                          )
                        ],
                      ),
                      _isUserReplaying == true ? sizeVer(10) : sizeVer(0),
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
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
