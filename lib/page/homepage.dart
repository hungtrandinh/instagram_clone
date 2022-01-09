// ignore_for_file: implementation_imports
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:social_app/blocs/api_image_blocs/api_image_bloc.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_blocs.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_event.dart';
import 'package:social_app/blocs/feeds/feeds_blocs.dart';
import 'package:social_app/blocs/feeds/feeds_event.dart';
import 'package:social_app/blocs/like_cubit/like_cubit.dart';
import 'package:social_app/blocs/nofitico_blocs/notifition_state.dart';
import 'package:social_app/blocs/nofitico_blocs/notifiton_bloc.dart';
import 'package:social_app/model/user.dart';
import 'package:social_app/page/careate_post.dart';
import 'package:social_app/page/list_meseenger.dart';
import 'package:social_app/page/messenger_page.dart';
import 'package:social_app/page/notifition_page.dart';
import 'package:social_app/page/photoAPI.dart';
import 'package:social_app/page/profile.dart';
import 'package:social_app/page/seach_page.dart';
import 'package:social_app/repositories/post_reponsitories.dart';
import 'package:social_app/values/app_textstyle.dart';
import 'package:social_app/widgets/feeds_widget/post_feeds.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  _DemoPageState createState() => _DemoPageState();
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

class _DemoPageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Scaffold(
      backgroundColor: Color(0xFf242A37),
      appBar: AppBar(
        title: Text(
          "HomePage",
          style: AppTextStyle.LoginStyle2,
        ),
        elevation: 0,
        backgroundColor: Color(0xFf242A37),
        actions: [
          IconButton(
              onPressed: () {
                context.read<CubitImage>().seachImage(query: "cay");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GetImageApi()));
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                context.read<AppBloc>().add(UserLogOut());
              },
              icon: Icon(Icons.chevron_right_sharp))
        ],
      ),
      body: BlocProvider<Post_Feed_Bloc>(
          create: (context) => Post_Feed_Bloc(
              postReponsitoris: context.read<PostReponsitoris>(),
              likeCubitt: context.read<LikeCubitt>(),
              appBloc: context.read<AppBloc>())
            ..add(Changerequest()),
          child: PostFeeds()),
      bottomNavigationBar: BlocConsumer<NotifitionBloc, NotifitionState>(
          listener: (context, state) {
        if (state.notificationStatus == NotificationStatus.loaded) {
          BotToast.showNotification(
              leading: (cancel) => SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: IconButton(
                    icon: Icon(Icons.download, color: Colors.redAccent),
                    onPressed: cancel,
                  )),
              title: (_) => Text('Dowload Thành Công !'),
              trailing: (cancel) => IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: cancel,
                  ));
        }
      }, builder: (context, state) {
        if (state.notificationStatus == NotificationStatus.loaded) {
          BotToast.showNotification(
              leading: (cancel) => SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: IconButton(
                    icon: Icon(Icons.download, color: Colors.redAccent),
                    onPressed: cancel,
                  )),
              title: (_) => Text('Dowload Thành Công !'),
              trailing: (cancel) => IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: cancel,
                  ));
        }
        return BottomNavigationBar(
          backgroundColor: Color(0Xff242A37),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Color(0Xff242A37),
            ),
            BottomNavigationBarItem(
                icon: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListMeseenger()));
                    },
                    icon: Icon(Icons.message)),
                label: 'Business',
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreatePostPage()));
                  },
                  icon: Icon(Icons.add)),
              label: 'School',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotifitionPage()));
                  },
                  icon: Icon(Icons.notifications)),
              label: 'School',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(
                                uid: user.id!,
                              )));
                },
                icon: Icon(Icons.perm_device_information),
              ),
              label: 'School',
            ),
          ],
          selectedItemColor: Colors.amber[800],
        );
      }),
    );
    // });
  }
}

Widget buildItem(BuildContext context, DocumentSnapshot? document) {
  User? user = FirebaseAuth.instance.currentUser;
  String udi = user!.uid;
  if (document != null) {
    final MyUser myUser =
        MyUser.fromJson(document.data() as Map<String, dynamic>);
    if (myUser.id != udi) {
      return Container(
        // color: Color(0xffEAECEF),
        child: TextButton(
          child: Row(
            children: <Widget>[
              Material(
                child: myUser.profilePictureURL != null
                    ? Image.network(
                        myUser.profilePictureURL!,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 50,
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, object, stackTrace) {
                          return Icon(
                            Icons.account_circle,
                            size: 50,
                            color: Colors.black45,
                          );
                        },
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Colors.black45,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Nickname: ${myUser.name}',
                          maxLines: 1,
                          style: AppTextStyle.LoginStyle5,
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                      ),
                      Container(
                        child: Text(
                          'Your seen: ${myUser.email}',
                          maxLines: 1,
                          style: TextStyle(color: Colors.grey),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20),
                ),
              ),
            ],
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color(0xff1E2432),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ABC(
                  UrlPeerId: myUser.profilePictureURL ?? 'xxx',
                  peerID: myUser.id!,
                  peerNickName: myUser.name!,
                ),
              ),
            );
          },
        ),
        margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
      );
    }
  }
  return Center(
    child: CupertinoActivityIndicator(),
  );
}
