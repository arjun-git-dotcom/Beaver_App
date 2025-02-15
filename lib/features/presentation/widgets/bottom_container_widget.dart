import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';

class BottomContainerWidget extends StatelessWidget {
  final Color? color;
  final String? text;
  final VoidCallback? onTapListener;
  const BottomContainerWidget(
      {super.key, this.color, this.text, this.onTapListener});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapListener,
      child: Container(width: double.infinity,
      height: 50,
      decoration:  BoxDecoration(color: color),child:  Center(child: Text('$text',style:const  TextStyle(color: backgroundColor),))),
    );
  }
}
