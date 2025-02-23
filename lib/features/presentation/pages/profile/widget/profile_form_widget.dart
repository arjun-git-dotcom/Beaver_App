import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';

class ProfileFormWidget extends StatefulWidget {
  final String? title;
  final Key? fieldKey;
  final TextEditingController ?controller;

  const ProfileFormWidget({super.key, this.title, this.fieldKey,this.controller});

  @override
  State<ProfileFormWidget> createState() => _ProfileFormWidgetState();
}

class _ProfileFormWidgetState extends State<ProfileFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title!),
          TextFormField(
            key: widget.fieldKey,
            controller: widget.controller,
          ),
        ],
      ),
    );
  }
}
