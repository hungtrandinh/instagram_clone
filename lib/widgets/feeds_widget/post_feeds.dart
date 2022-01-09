import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/feeds/feeds_blocs.dart';
import 'package:social_app/blocs/feeds/feeds_event.dart';
import 'package:social_app/blocs/feeds/feeds_state.dart';
import 'package:social_app/blocs/like_cubit/like_cubit.dart';
import 'package:social_app/page/comment.dart';
import 'package:social_app/page/profile.dart';

import 'package:social_app/values/app_textstyle.dart';

class PostFeeds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Post_Feed_Bloc, FeedState>(builder: (context, state) {
      return RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(
            Duration(milliseconds: 300),
          );
          context.read<Post_Feed_Bloc>().add(Changerequest());
        },
        child: state.status == FeedStatus.loaded
            ? ListView.builder(
                itemCount: state.postList.length,
                itemBuilder: (context, index) {
                  final likedPostState = context.watch<LikeCubitt>().state;
                  return Container(
                    child: Column(
                      children: [
                        InkWell(
                          child: Card(
                              color: Color(0xff242A37),
                              shadowColor: Colors.black,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        8 /
                                        9,
                                    height: 100,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: CircleAvatar(
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.fill,
                                                      imageUrl: state
                                                          .postList[index]!
                                                          .author
                                                          .profilePictureURL!),
                                                ),
                                                radius: 20,
                                              ),
                                            ),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => Profile(
                                                                  uid: state
                                                                      .postList[
                                                                          index]!
                                                                      .author
                                                                      .id!)));
                                                    },
                                                    child: Text(
                                                        "${state.postList[index]!.author.name}",
                                                        style: AppTextStyle
                                                            .nameUser),
                                                  ),
                                                  Text(
                                                      "${state.postList[index]!.dateTime.toString().split('.')[0]}",
                                                      style: AppTextStyle
                                                          .datimepost)
                                                ])
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Text(
                                                "${state.postList[index]!.caption}",
                                                maxLines: 30,
                                                style: AppTextStyle.caption,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  state.postList[index]!.imageUrl == null
                                      ? SizedBox()
                                      : CachedNetworkImage(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              8 /
                                              9,
                                          height: 300,
                                          imageUrl:
                                              state.postList[index]!.imageUrl,
                                          fit: BoxFit.fill),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          8 /
                                          9,
                                      child: Row(children: [
                                        IconButton(
                                            onPressed: () {
                                              if (likedPostState.likepost
                                                      .contains(state
                                                          .postList[index]!
                                                          .id) ==
                                                  false) {
                                                context
                                                    .read<LikeCubitt>()
                                                    .likePost(
                                                        postModel: state
                                                            .postList[index]!);
                                              } else {
                                                context
                                                    .read<LikeCubitt>()
                                                    .unlikePost(
                                                        state.postList[index]!);
                                              }
                                            },
                                            icon: likedPostState.likepost
                                                    .contains(state
                                                        .postList[index]!.id)
                                                ? const Icon(Icons.favorite,
                                                    color: Colors.red)
                                                : const Icon(
                                                    Icons.favorite_outline,
                                                    color: Colors.white,
                                                  )),
                                        likedPostState.likepost.contains(
                                                state.postList[index]!.id)
                                            ? Text(
                                                "${state.postList[index]!.likes + 1}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15),
                                              )
                                            : Text(
                                                "${state.postList[index]!.likes}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 15),
                                              ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Comments(
                                                            list:
                                                                state.postList[
                                                                    index]!)));
                                          },
                                          icon: Icon(
                                            Icons.comment,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ]))
                                ],
                              )),
                        )
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Theme(
                    data: ThemeData(
                        cupertinoOverrideTheme:
                            CupertinoThemeData(brightness: Brightness.dark)),
                    child: CupertinoActivityIndicator())),
      );
    });
  }
}
