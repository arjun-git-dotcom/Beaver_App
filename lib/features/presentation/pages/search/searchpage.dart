import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/presentation/pages/search/search_widget.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  late TextEditingController searchcontroller;

  @override
  void initState() {
    searchcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: SingleChildScrollView(
        child: Column(
          
          children: [
            SearchWidget(controller: searchcontroller),
            sizeVer(10),
            GridView.builder(
              itemCount: 12,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
                gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 5,mainAxisSpacing: 5,
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return Container(height: 30, width: 30,color: secondaryColor,);
                })
          ],
        ),
                ),
              ),
      ),
    );
  }
}
