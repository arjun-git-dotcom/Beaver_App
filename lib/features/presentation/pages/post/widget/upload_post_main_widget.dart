import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/storage/upload_image_to_storage.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/pages/profile/widget/profile_form_widget.dart';
import 'package:social_media/features/widget_profile.dart';
import 'package:uuid/uuid.dart';
import 'package:social_media/injection_container.dart' as di;

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostMainWidget({required this.currentUser, super.key});

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
  File? _image;
  late TextEditingController _descriptionController;
  bool isUploading = false;

  @override
  void initState() {
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform
          .getImageFromSource(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('no image is selected');
        }
      });
    } catch (e) {
      print('some error occured');
    }
  }

  _uploadPostWidget() {
    return Scaffold(
      body: Center(
          child: GestureDetector(
        onTap: () => selectImage(),
        child: Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: secondaryColor,
          ),
          child: const Icon(
            Icons.upload,
            size: 40,
            color: backgroundColor,
          ),
        ),
      )),
    );
  }

  _submitPost() {
    setState(() {
      isUploading = true;
    });
    di
        .sl<UploadImageToStorageUsecase>()
        .call(_image, true, "posts")
        .then((imageUrl) {
      _createSubmitPost(image: imageUrl);
    });
  }

  _createSubmitPost({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .createPost(
            post: PostEntity(
                description: _descriptionController.text,
                createAt: Timestamp.now(),
                creatorUid: widget.currentUser.uid,
                likes: [],
                postId: Uuid().v1(),
                postImageUrl: image,
                totalComments: 0,
                totalLikes: 0,
                username: widget.currentUser.username,
                userProfileUrl: widget.currentUser.profileUrl))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      isUploading = false;
      _descriptionController.clear();
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? _uploadPostWidget()
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: backgroundColor,
              leading: GestureDetector(
                  onTap: () => setState(() {
                        _image = null;
                      }),
                  child: const Icon(Icons.close)),
              actions: [
                GestureDetector(
                    onTap: () {
                      _submitPost();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.forward),
                    ))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: profileWidget(
                              imageUrl: widget.currentUser.profileUrl))),
                  sizeVer(10),
                  Text('${widget.currentUser.username}'),
                  sizeVer(10),
                  SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: profileWidget(image: _image),
                  ),
                  sizeVer(10),
                   ProfileFormWidget(
                    title: 'Description',
                    controller: _descriptionController,
                  ),
                  sizeVer(10),

                  isUploading==true?const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    
                    children: [
                      
                      
                      Text('Uploading ...'),CircularProgressIndicator()],):const SizedBox(height: 0,width: 0,),
                ],
              ),
            ),
          );
  }
}
