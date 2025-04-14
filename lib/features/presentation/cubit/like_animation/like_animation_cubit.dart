import 'package:flutter_bloc/flutter_bloc.dart';

class LikeAnimationCubit extends Cubit<Map<String, bool>> {
  LikeAnimationCubit() : super({});

  void startAnimation(String postId) {
    Map<String, bool> updatedState = Map.from(state);
    updatedState[postId] = true;
    emit(updatedState);
  }

  void resetAnimation(String postId) {
    Map<String, bool> updatedState = Map.from(state);
    updatedState[postId] = false;
    emit(updatedState);
  }

  bool isAnimating(String postId) {
    return state[postId] ?? false;
  }
}