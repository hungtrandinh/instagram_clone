import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/edit_profile_blocs/edit_profile_bloc.dart';
import 'package:social_app/blocs/profile_blocs/profile_bloc.dart';
import 'package:social_app/repositories/profile_reponsitories.dart';
import 'package:social_app/repositories/repositories.dart';

import 'package:social_app/widgets/editprofile/editprofileAddImage.dart';

class EditProfilePage extends StatefulWidget {
  final String image;

  const EditProfilePage({Key? key, required this.image}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState(image);
}

class _EditProfilePageState extends State<EditProfilePage> {
  final String image;

  _EditProfilePageState(this.image);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileBloc>(
      create: (context) => EditProfileBloc(
          settingProvider: context.read<SettingProvider>(),
          repositoryProvider: context.read<AuthenticationRepository>(),
          editProfile: context.read<EditProfile>()),
      child: AddImageProfile(
        path: image,
      ),
    );
  }
}
