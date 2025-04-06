import 'package:flutter_bloc/flutter_bloc.dart';

class LikeAnimationCubit extends Cubit<bool> {
  LikeAnimationCubit() : super(false);

  resetAnimation() => emit(false);
  startAnimation() => emit(true);
}
