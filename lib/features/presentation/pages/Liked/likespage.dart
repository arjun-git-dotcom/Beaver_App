import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';

class Likespage extends StatelessWidget {
  const Likespage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: blueColor,
      centerTitle: true,
       title: const Text('Liked Posts',style: TextStyle(fontSize: 20,color: backgroundColor),)),);
  }
}