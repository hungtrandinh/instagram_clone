import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

import 'package:social_app/blocs/app_login_blocs/app_login_blocs.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_event.dart';
import 'package:social_app/page/homepage.dart';
import 'package:social_app/page/profile.dart';
import 'package:social_app/values/app_textstyle.dart';

class ListMeseenger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userid = user!.uid;
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Color(0xFf242A37),
      appBar: AppBar(
        title: Text(
          "Messages",
          style: AppTextStyle.LoginStyle2,
        ),
        elevation: 0,
        backgroundColor: Color(0xFf242A37),
        actions: [
          IconButton(
              onPressed: () {
                context.read<AppBloc>().add(UserLogOut());
              },
              icon: Icon(Icons.chevron_right_sharp))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('users').limit(100).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(context, snapshot.data!.docs[index]),
              itemCount: snapshot.data!.docs.length,
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0Xff242A37),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0Xff242A37),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Business',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => Profile()));
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
                              uid: userid,
                            )));
              },
              icon: Icon(Icons.perm_device_information),
            ),
            label: 'School',
          ),
        ],
        selectedItemColor: Colors.amber[800],
      ),
    ));
  }
}
