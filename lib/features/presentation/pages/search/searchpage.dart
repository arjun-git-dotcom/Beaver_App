
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/presentation/cubit/posts/post_cubit.dart';
import 'package:social_media/features/presentation/pages/search/search_main_widget.dart';
import "package:social_media/injection_container.dart" as di;

class Searchpage extends StatelessWidget {
  const Searchpage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
        create: (context) => di.sl<PostCubit>(), child: const SearchMainWidget());
  }
}
