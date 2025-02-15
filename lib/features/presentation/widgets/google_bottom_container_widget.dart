import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_media/constants.dart';

class GoogleBottomContainerWidget extends StatelessWidget {
  final Color? color;
  final String? text;
  final VoidCallback? onTapListener;
  final String? image;
  const GoogleBottomContainerWidget(
      {super.key, this.color, this.text, this.onTapListener,this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapListener,
      child: Container(
        
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,border: Border.all(color: primaryColor)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               SvgPicture.asset(image!,height: 30,width: 30,),
               sizeHor(10),
                Text(
                            '$text',
                            style: const TextStyle(color: primaryColor),
                          ),
              ],
            ),
          )),
    );
  }
}
