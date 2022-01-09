import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_app/blocs/post_bloc/post_cubit.dart';
import 'package:social_app/repositories/post_reponsitories.dart';
import 'package:social_app/widgets/create_post/create_post_widget.dart';

class CreatePostPage extends StatefulWidget {
  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => PostCubit(
        postReponsitoris: context.read<PostReponsitoris>(),
      ),
      child: CreatePostWidget(),
    );
  }
}
