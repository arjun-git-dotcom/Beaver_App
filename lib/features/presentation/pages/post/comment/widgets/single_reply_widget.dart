import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/user/get_current_uuid_usecase.dart';
import 'package:social_media/features/presentation/cubit/replys/reply_cubit.dart';
import 'package:social_media/features/presentation/widgets/widget_profile.dart';
import 'package:social_media/injection_container.dart' as di;

class SingleReplyWidget extends StatefulWidget {
  final ReplyEntity reply;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  const SingleReplyWidget(
      {this.onLikeClickListener,
      this.onLongPressListener,
      required this.reply,
      super.key});

  @override
  State<SingleReplyWidget> createState() => _SingleReplyWidgetState();
}

class _SingleReplyWidgetState extends State<SingleReplyWidget> {
  String _currentUid = '';

  @override
  void initState() {
    BlocProvider.of<ReplyCubit>(context).readReply(
        reply: ReplyEntity(
            postId: widget.reply.postId, commentId: widget.reply.commentId));
    
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      _currentUid = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.onLongPressListener,
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
                          InkWell(
                            onTap: widget.onLikeClickListener,
                            child: Icon(widget.reply.likes!.contains(_currentUid)?
                            MdiIcons.heart:
                            MdiIcons.heartOutline,color: redColor)
                            
                            
                            )
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
