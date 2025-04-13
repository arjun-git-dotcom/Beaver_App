import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/widget_profile.dart';

class SingleReplyWidget extends StatefulWidget {
  final ReplyEntity reply;
  const SingleReplyWidget({required this.reply,super.key});

  @override
  State<SingleReplyWidget> createState() => _SingleReplyWidgetState();
}

class _SingleReplyWidgetState extends State<SingleReplyWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: widget.reply.profileUrl),
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
                          Text(widget.reply.username!),
                          Icon(MdiIcons.heartOutline, color: primaryColor)
                        ],
                      ),
                      Text(widget.reply.description!),
                      Row(
                        children: [
                            Text(
                                DateFormat("dd/MMM/yyyy")
                                    .format(widget.reply.createdAt!.toDate()),
                                style: const TextStyle(
                                    color: darkgreyColor, fontSize: 12),
                              ),
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
