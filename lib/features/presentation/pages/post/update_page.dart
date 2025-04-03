import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/pages/profile/widget/profile_form_widget.dart';
import 'package:social_media/features/widget_profile.dart';

class UpdatePostPage extends StatefulWidget {
  final PostEntity post;
  const UpdatePostPage({required this.post, super.key});

  @override
  State<UpdatePostPage> createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostPage> {
  TextEditingController? _descriptionController;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.post.description);
    super.initState();
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
              padding: EdgeInsets.all(8),
              child: GestureDetector(
                  onTap: () {
                    _updatepost(widget.post);
                  },
                  child: Icon(Icons.check_circle_outline_outlined)))
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
              Container(
                  width: double.infinity,
                  child: profileWidget(imageUrl: widget.post.postImageUrl)),
              sizeVer(10),
              const Text('Enter description'),
              TextField(
                controller: _descriptionController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _updatepost(PostEntity post) {
    BlocProvider.of<PostCubit>(context).updatePost(post: post);
  }
}
