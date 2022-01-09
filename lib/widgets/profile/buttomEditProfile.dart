import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:social_app/blocs/profile_blocs/profile_bloc.dart';
import 'package:social_app/blocs/profile_blocs/profile_event.dart';
import 'package:social_app/page/editprofile_page.dart';

class ButomEditProfile extends StatelessWidget {
  final String image;
  final bool isFolowing;
  final String userid;

  const ButomEditProfile(
      {Key? key,
      required this.image,
      required this.isFolowing,
      required this.userid})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String currentUser = user!.uid;
    return currentUser == userid
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color(0xffF78361), shadowColor: Colors.lightBlue),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                            image: image,
                          )));
            },
            child: Text("Edit Profile"))
        : TextButton(
            style: TextButton.styleFrom(
              backgroundColor: isFolowing
                  ? Colors.grey[300]
                  : Theme.of(context).primaryColor,
            ),
            onPressed: () {
              isFolowing
                  ? context.read<EditProfile>().add(
                        ProfileUnfollowUserEvent(),
                      )
                  : context.read<EditProfile>().add(
                        ProfileFollowUserEvent(),
                      );
            },
            child: Text(
              isFolowing ? 'Unfollow' : 'Follow',
              style: TextStyle(
                  fontSize: 16,
                  color: isFolowing ? Colors.black : Colors.white),
            ),
          );
  }
}
