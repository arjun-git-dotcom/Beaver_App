
import 'dart:io';
import 'package:social_media/features/domain/repository/firebase_repository.dart';

class UploadImageToStorageUsecase {
  final FirebaseRepository repository;
  UploadImageToStorageUsecase({required this.repository,});


  Future<String> call(File?imageFile,bool isPost,String childName) {
    return repository.uploadImageToStorage(
     imageFile,isPost,childName
    );
  }
}
