import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';
import 'package:social_media/features/domain/usecase/firebase_usecases/storage/upload_image_to_storage.dart';
import 'package:social_media/features/presentation/cubit/form/form_cubit.dart';
import 'package:social_media/features/presentation/cubit/image/image_cubit.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/pages/post/widget/camera_widget.dart';
import 'package:social_media/features/presentation/pages/profile/widget/profile_form_widget.dart';
import 'package:social_media/features/presentation/widgets/widget_profile.dart';
import 'package:uuid/uuid.dart';
import 'package:social_media/injection_container.dart' as di;

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostMainWidget({required this.currentUser, super.key});

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
  late TextEditingController _descriptionController;


  @override
  void initState() {
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future selectImage() async {
    try {
    Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => CameraCaptureWidget()),
);
    } catch (e) {
      print('some error occured');
    }
  }



  _submitPost() {
    context.read<FormCubit>().setForm();
    final image = context.read<ImageCubit>().state;
    di
        .sl<UploadImageToStorageUsecase>()
        .call(image, true, "posts")
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
                likes: const [],
                postId: const Uuid().v1(),
                postImageUrl: image,
                totalComments: 0,
                totalLikes: 0,
                username: widget.currentUser.username,
                userProfileUrl: widget.currentUser.profileUrl))
        .then((value) => _clear());
  }

  _clear() {
   
    context.read<FormCubit>().resetForm();
      _descriptionController.clear();
      context.read<ImageCubit>().clearImage();
   
  }

 @override
Widget build(BuildContext context) {
  final image = context.watch<ImageCubit>().state;

  return image == null
      ? Scaffold(
          backgroundColor: themeColor,
          body: Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: () => selectImage(),
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: blueColor.withOpacity(0.8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.upload_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 12),
       Text(
        'Tap to Take Selfie',
        style: AppTextStyle.stylishfont(
          
          color: Colors.black,
       
        ),
      ),
    ],
  ),
),

        )
      : Scaffold(
          backgroundColor: themeColor,
          appBar: AppBar(
            backgroundColor: themeColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => context.read<ImageCubit>().clearImage(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.send_rounded, color: blueColor),
                onPressed: _submitPost,
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: profileWidget(
                            imageUrl: widget.currentUser.profileUrl),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.currentUser.username ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 400,
                    child: profileWidget(image: image),
                  ),
                ),
                const SizedBox(height: 20),
                ProfileFormWidget(
                  title: 'Write a caption...',
                  controller: _descriptionController,
                ),
                const SizedBox(height: 20),
                context.watch<FormCubit>().state
                    ?  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Uploading...',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 14)),
                         const  SizedBox(width: 10),
                         SpinkitConstants().spinkitcircle(blueColor)
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        );
}

}
