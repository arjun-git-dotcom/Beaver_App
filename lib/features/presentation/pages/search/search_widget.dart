import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  const SearchWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(60)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor)),
        ),
      ),
    );
  }
}
