import 'package:flutter_bloc/flutter_bloc.dart';

class CommentflagCubit extends Cubit<bool> {
  CommentflagCubit() : super(false);

  setCommentUpdate() => emit(true);
  resetCommentUpdate() => emit(false);
}
