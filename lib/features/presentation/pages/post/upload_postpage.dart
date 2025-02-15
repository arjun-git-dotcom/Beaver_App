import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';

class Postpage extends StatelessWidget {
  const Postpage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: Center(child: Container(
      
      height: 100,width: 100,
     
      decoration:const  BoxDecoration(shape: BoxShape.circle, color: secondaryColor,),
  
    child: const Icon(Icons.upload,size: 40,color: backgroundColor,),)),);
  }
}