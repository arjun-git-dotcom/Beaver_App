import 'package:flutter_bloc/flutter_bloc.dart';

class FormCubit extends Cubit<bool> {
  FormCubit() : super(false);

  void setForm() {
    emit(true);
  }

  void resetForm() {
    emit(false);
  }
}
