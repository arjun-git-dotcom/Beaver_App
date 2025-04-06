import 'package:flutter_bloc/flutter_bloc.dart';

class UserReplyFlagCubit extends Cubit<bool> {
  UserReplyFlagCubit() : super(false);
  toggleUpdateReply() => emit(!state);
  setUserReply() => emit(true);
  resetUpdateReply() => emit(false);
}
