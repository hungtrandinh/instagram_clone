import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_app/values/app_assets_icons.dart';

class UserProfileImage extends StatelessWidget {
  final String name;

  final String imageUrl;

  final double radius;
  final double size;

  const UserProfileImage({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.radius,
    required this.size,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: ClipOval(
        child: imageUrl != 'xxx'
            ? CachedNetworkImage(
                width: size, height: size, fit: BoxFit.fill, imageUrl: imageUrl)
            : SizedBox(
                width: size,
                height: size,
                child: Image.asset(
                  AppIcon.avata,
                  fit: BoxFit.fill,
                ),
              ),
      ),
      radius: radius,
    );
  }
}
