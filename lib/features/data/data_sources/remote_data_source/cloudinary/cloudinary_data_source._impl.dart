import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/constants.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/cloudinary/cloudinary_data_source.dart';

class CloudinaryRepositoryImpl extends CloudinaryRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  CloudinaryRepositoryImpl(
      {required this.firebaseFirestore, required this.firebaseAuth});
  @override
  Future<String> uploadImageToStorage(
      File? imageFile, String childName, bool isPost) async {
    if (imageFile == null) return "";

    try {
      String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
      const String uploadPreset = CloudinaryConstants.uploadPreset;

      String url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

      var request = http.MultipartRequest("POST", Uri.parse(url))
        ..fields['upload_preset'] = uploadPreset
        ..fields['folder'] = childName
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseData);

      if (response.statusCode == 200) {
        toast('image uploaded successfully');
        final currentUser = firebaseAuth.currentUser!;

        final userDoc =
            firebaseFirestore.collection('users').doc(currentUser.uid);
        userDoc.update({'profileUrl': jsonData['secure_url']});
        return jsonData['secure_url'];
      } else {
        throw Exception("Failed to upload image");
      }
    } catch (e) {
      toast("Cloudinary Upload Error: $e");
      return "";
    }
  }
}
