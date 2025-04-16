import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/presentation/cubit/replys/reply_cubit.dart';
import 'package:social_media/features/presentation/pages/post/comment/widgets/update_reply_main_widget.dart';
import 'package:social_media/injection_container.dart' as di;
class UpdateReplyPage extends StatelessWidget {
  final ReplyEntity reply;
  const UpdateReplyPage({required this.reply, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ReplyCubit>(),
      child: UpdateReplyMainWidget(reply: reply));
  }
}
