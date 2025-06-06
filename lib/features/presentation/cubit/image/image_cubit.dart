import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

class ImageCubit extends Cubit<File?> {
  ImageCubit() : super(null);

  void selectImage(File image) => emit(image);
  void clearImage() => emit(null);
}
