import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/presentation/cubit/savedposts/savedpost_cubit.dart';
import 'package:social_media/features/presentation/savedpost/savedpost_main_widget.dart';
import 'package:social_media/injection_container.dart'as di;

class SavedPostpage extends StatelessWidget {
  const SavedPostpage({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
        providers: [
          BlocProvider<SavedpostCubit>(
            create: (context) => di.sl<SavedpostCubit>(),
          ),
        ],
        child:  const SavedpostMainWidget(
      
        ));
  }
}