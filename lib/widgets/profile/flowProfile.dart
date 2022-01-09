import 'package:flutter/material.dart';
import 'package:social_app/values/app_asset_editprofile/ediitprofile_textstyle.dart';

class FlowProfile extends StatelessWidget {
  @override
  final int post;
  final int flowing;
  final int flower;

  const FlowProfile(
      {Key? key,
      required this.post,
      required this.flowing,
      required this.flower})
      : super(key: key);
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "${post}",
                style: ProfileTextStyle.flowNumber,
              ),
              Text(
                "Bài Viết",
                style: ProfileTextStyle.flowString,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "${flower}",
                style: ProfileTextStyle.flowNumber,
              ),
              Text(
                "Người T Dõi",
                style: ProfileTextStyle.flowString,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "${flowing}",
                style: ProfileTextStyle.flowNumber,
              ),
              Text(
                "Đang T Dõi",
                style: ProfileTextStyle.flowString,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
