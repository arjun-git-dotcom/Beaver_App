import 'package:flutter_bloc/flutter_bloc.dart';

class UserReplyFlagCubit extends Cubit<String?> {
  UserReplyFlagCubit() : super(null); 

  void startReplyingTo(String commentId) => emit(commentId);

  void stopReplying() => emit(null);

  bool isReplyingTo(String commentId) => state == commentId;
}

