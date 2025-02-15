import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';

class UpdatePostPage extends StatelessWidget {
  const UpdatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
            )),
        actions: const [
          Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.check_circle_outline_outlined))
        ],
        title: const Text('Update Post'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
              ),
            ),
            sizeVer(10),
            const Center(
                child: Text(
              'Username',
              style: TextStyle(fontWeight: FontWeight.w500),
            )),
            sizeVer(10),
            Container(
              height: 200,
              width: double.infinity,
              color: secondaryColor,
            ),
            sizeVer(10),
            const Text('Description'),
            sizeVer(40),
            const Divider()
          ],
        ),
      ),
    );
  }
}
