import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkCubit extends Cubit<Set<String>> {
  BookmarkCubit() : super({});

  void toggleBookmark(String postId) {
    if (state.contains(postId)) {
      emit({...state}..remove(postId));
    } else {
      emit({...state}..add(postId));
    }
  }

   bool isBookmarked(String postId) => state.contains(postId);
}
