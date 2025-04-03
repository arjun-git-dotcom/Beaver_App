import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/storage/upload_image_to_storage.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/widget_profile.dart';
import 'package:social_media/injection_container.dart' as di;

class UpdatePostMainWidget extends StatefulWidget {
  final PostEntity post;
  const UpdatePostMainWidget({required this.post, super.key});

  @override
  State<UpdatePostMainWidget> createState() => _UpdatePostMainWidgetState();
}

class _UpdatePostMainWidgetState extends State<UpdatePostMainWidget> {
  TextEditingController? _descriptionController;
  File? _image;
  bool _uploading = false;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.post.description);

    super.initState();
  }

  Future selectImage() async {
    try {
      // ignore: invalid_use_of_visible_for_testing_member
      final pickedImage = await ImagePicker.platform
          .getImageFromSource(source: ImageSource.gallery);
      setState(() {
        if (pickedImage != null) {
          _image = File(pickedImage.path);
        }
      });
    } catch (e) {
      print("some problem occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
            )),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                  onTap: () {
                    _updatePost();
                  },
                  child: const Icon(Icons.check_circle_outline_outlined)))
        ],
        title: const Text('Update Post'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                height: 30,
                width: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: profileWidget(),
                ),
              )),
              sizeVer(10),
              const Center(
                  child: Text(
                'Username',
                style: TextStyle(fontWeight: FontWeight.w500),
              )),
              sizeVer(10),
              Stack(children: [
                SizedBox(
                    width: double.infinity,
                    child: profileWidget(
                        imageUrl: widget.post.postImageUrl, image: _image)),
                Positioned(
                    bottom: 0,
                    right: 5,
                    child: GestureDetector(
                      onTap: selectImage,
                      child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: backgroundColor),
                          child: const Icon(
                            Icons.edit,
                            color: primaryColor,
                            size: 25,
                          )),
                    ))
              ]),
              sizeVer(10),
              const Text('Enter description'),
              TextField(
                controller: _descriptionController,
              ),
                 _uploading==true?const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    
                    children: [
                      
                      
                      Text('Updating ...'),CircularProgressIndicator()],):const SizedBox(height: 0,width: 0,),
            ],
          ),
        ),
      ),
    );
  }

  _updatePost() {
    setState(() {
      _uploading = true;
    });

    if (_image == null) {
      _submitUpdatePost(image: widget.post.postImageUrl!);
    } else {
      di
          .sl<UploadImageToStorageUsecase>()
          .call(_image, true, "posts")
          .then((imageUrl) {
        _submitUpdatePost(image: imageUrl);
      });
    }
  }

  _submitUpdatePost({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .updatePost(
            post: PostEntity(
                creatorUid: widget.post.creatorUid,
                postId: widget.post.postId,
                postImageUrl: image,
                description: _descriptionController!.text))
        .then((value) {
      return _clear();
    });
  }

  _clear() {
    setState(() {
      _image = null;
      _descriptionController!.clear();
      Navigator.pop(context);
      _uploading = false;
    });
  }
}
