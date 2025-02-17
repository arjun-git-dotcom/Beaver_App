import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';

Widget profileWidget({String? imageUrl, File? image}) {
  if (image != null) {
    return CircleAvatar(
      backgroundColor: blueColor,
      radius: 50,
      backgroundImage: FileImage(image), 
    );
  }

  if (imageUrl != null && imageUrl.isNotEmpty) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: CachedNetworkImageProvider(imageUrl), 
      backgroundColor: blueColor, 
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            const CircularProgressIndicator(),
        errorWidget: (context, url, error) => Image.asset(
          "assets/propicjpg-removebg-preview.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  return const CircleAvatar(
    backgroundColor: blueColor,
    radius: 50,
    backgroundImage: AssetImage("assets/propicjpg-removebg-preview.png"), 
  );
}
