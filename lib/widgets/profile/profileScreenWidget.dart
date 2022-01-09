import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:social_app/blocs/like_cubit/like_cubit.dart';
import 'package:social_app/blocs/post_bloc/post_cubit.dart';
import 'package:social_app/model/post.dart';
import 'package:social_app/page/comment.dart';
import 'package:social_app/page/messenger_page.dart';
import 'package:social_app/page/show_image.dart';
import 'package:social_app/values/app_asset_editprofile/ediitprofile_textstyle.dart';
import 'package:social_app/values/app_assets_colors.dart';
import 'package:social_app/values/app_textstyle.dart';
import 'package:social_app/widgets/profile/buttomEditProfile.dart';
import 'package:social_app/widgets/profile/flowProfile.dart';
import 'package:social_app/widgets/profile/userProfileImage.dart';

class ProfileWidget extends StatefulWidget {
  final String? imageUrl;
  final String? name;
  final bool? isfolowing;
  final String? currenUserid;
  final int flowing;
  final int flower;
  final int post;
  final List<PostModel?> list;

  const ProfileWidget(
      {Key? key,
      required this.list,
      required this.currenUserid,
      required this.imageUrl,
      required this.name,
      required this.isfolowing,
      required this.flowing,
      required this.post,
      required this.flower})
      : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  int indexpage = 0;
  Color color = ColorConstants.buttoncolor;
  Color color1 = ColorConstants.buttoncolor;
  Color color2 = Colors.white;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String currentUser = user!.uid;
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: UserProfileImage(
                                size: 95,
                                radius: 60,
                                imageUrl: widget.imageUrl!,
                                name: widget.name!),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: FlowProfile(
                                  flower: widget.flower,
                                  flowing: widget.flowing,
                                  post: widget.list.length,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            currentUser != widget.currenUserid
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 20),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.white70),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) => ABC(
                                                            peerID: widget
                                                                .currenUserid!,
                                                            UrlPeerId: widget
                                                                .imageUrl!,
                                                            peerNickName:
                                                                widget.name!)));
                                              },
                                              child: Text("Nhắn Tin",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ),
                                      ],
                                    ))
                                : SizedBox()
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 3 / 10,
                      child: Center(
                        child: Text(
                          widget.name!,
                          style: ProfileTextStyle.nameUser,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ButomEditProfile(
                    image: widget.imageUrl!,
                    isFolowing: widget.isfolowing!,
                    userid: widget.currenUserid!,
                  ),
                )
              ],
            ),
          ),
        ),
        SliverAppBar(
          backgroundColor: Color(0xff1E2432),
          shadowColor: Colors.black54,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        indexpage = 0;
                        color1 = color;
                        color2 = Colors.white;

                        print(indexpage);
                      });
                    },
                    icon: Icon(
                      Icons.apps_rounded,
                      color: color1,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        indexpage = 1;
                        color2 = color;
                        color1 = Colors.white;
                      });
                    },
                    icon: Icon(Icons.art_track_sharp, color: color2))
              ],
            ),
          ),
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(),
        ),
        indexpage == 0
            ? SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = widget.list[index];
                    return Hero(
                      tag: "image",
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowImage(
                                        image: post!.imageUrl,
                                      )));
                        },
                        child: CachedNetworkImage(
                          imageUrl: post!.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  childCount: widget.list.length,
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                final post = widget.list[index];
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
                                  width:
                                      MediaQuery.of(context).size.width * 8 / 9,
                                  height: 100,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: CircleAvatar(
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.fill,
                                                      imageUrl: post!.imageUrl),
                                                ),
                                                radius: 20,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("${post.author.name}",
                                                      style: AppTextStyle
                                                          .nameUser),
                                                  SizedBox(height: 7),
                                                  Text(
                                                      "${post.dateTime.toString().split('.')[0]}",
                                                      style: AppTextStyle
                                                          .datimepost)
                                                ]),
                                          ),
                                          currentUser == widget.currenUserid
                                              ? IconButton(
                                                  onPressed: () {
                                                    context
                                                        .read<PostCubit>()
                                                        .deletepost(
                                                            equa:
                                                                post.imageUrl);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete_outlined,
                                                    color: Colors.white,
                                                  ))
                                              : SizedBox()
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              "${post.caption}",
                                              maxLines: 30,
                                              style: AppTextStyle.caption,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                post.imageUrl == null
                                    ? SizedBox()
                                    : CachedNetworkImage(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                8 /
                                                9,
                                        height: 300,
                                        imageUrl: post.imageUrl,
                                        fit: BoxFit.fill),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        8 /
                                        9,
                                    child: Row(children: [
                                      IconButton(
                                          onPressed: () {
                                            if (likedPostState.likepost
                                                    .contains(post.id) ==
                                                false) {
                                              context
                                                  .read<LikeCubitt>()
                                                  .likePost(postModel: post);
                                            } else {
                                              context
                                                  .read<LikeCubitt>()
                                                  .unlikePost(post);
                                            }
                                          },
                                          icon: likedPostState.likepost
                                                  .contains(post.id)
                                              ? const Icon(Icons.favorite,
                                                  color: Colors.red)
                                              : const Icon(
                                                  Icons.favorite_outline,
                                                  color: Colors.white,
                                                )),
                                      likedPostState.likepost.contains(post.id)
                                          ? Text(
                                              "${post.likes}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15),
                                            )
                                          : Text(
                                              "${post.likes}",
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
                                                      Comments(list: post)));
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
              }, childCount: widget.list.length)),
      ],
    );
  }
}
