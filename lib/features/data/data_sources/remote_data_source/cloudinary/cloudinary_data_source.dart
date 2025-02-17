import 'dart:io';

abstract class CloudinaryRepository {

    Future<String> uploadImageToStorage(
      File? imageFile, String childName, bool isPost);

  
}

