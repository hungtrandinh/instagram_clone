import 'package:flutter/material.dart';
import 'package:social_app/model/user.dart';
import 'package:social_app/page/profile.dart';
import 'package:social_app/widgets/profile/userProfileImage.dart';

class SuggestionTile extends StatelessWidget {
  final MyUser user;

  const SuggestionTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Profile(uid: user.id!)));
      },
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                UserProfileImage(
                  size: 50,
                  name: "hung",
                  radius: 46,
                  imageUrl: user.profilePictureURL != null
                      ? user.profilePictureURL!
                      : 'xxx',
                ),
                const SizedBox(height: 8),
                Text(
                  user.name!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
