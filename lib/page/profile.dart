import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_blocs.dart';
import 'package:social_app/blocs/profile_blocs/profile_bloc.dart';
import 'package:social_app/blocs/profile_blocs/profile_event.dart';
import 'package:social_app/blocs/profile_blocs/profile_state.dart';
import 'package:social_app/page/homepage.dart';
import 'package:social_app/repositories/post_reponsitories.dart';

import 'package:social_app/repositories/profile_reponsitories.dart';
import 'package:social_app/repositories/repositories.dart';
import 'package:social_app/widgets/profile/profileScreenWidget.dart';

class Profile extends StatelessWidget {
  final String uid;
  Profile({Key? key, required this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Color(0xff242A37),
      body: BlocProvider<EditProfile>(
          create: (context) => EditProfile(
                context.read<SettingProvider>(),
                context.read<PostReponsitoris>(),
                context.read<AuthenticationRepository>(),
              )..add(ChangeAvatarRequest(uid)),
          child: AAA(
            uid: uid,
          )),
    ));
  }
}

class AAA extends StatelessWidget {
  final String uid;

  const AAA({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditProfile(
      context.read<SettingProvider>(),
      context.read<PostReponsitoris>(),
      context.read<AuthenticationRepository>(),
    )..add(ChangeAvatarRequest(uid));
    return BlocBuilder<EditProfile, ProfileState>(builder: (context, state) {
      if (state.myUser.isEmpty) {
      } else {
        return MaterialApp(
          home: Scaffold(
            backgroundColor: Color(0xFf242A37),
            appBar: AppBar(
              backgroundColor: Color(0xFf242A37),
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
            ),
            body: Center(
              // child:  Text("${state.myUser.email}"),
              child: ProfileWidget(
                list: state.post!,
                flower: state.myUser.followers!,
                flowing: state.myUser.following!,
                post: 2,
                imageUrl: state.myUser.profilePictureURL == null
                    ? 'xxx'
                    : state.myUser.profilePictureURL,
                name: state.myUser.name!,
                currenUserid: uid,
                isfolowing: state.isFlowing,
              ),
            ),
          ),
        );
      }
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    });
  }
}
