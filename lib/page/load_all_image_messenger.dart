import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:social_app/model/messenger_chat.dart';
import 'package:social_app/repositories/chat_reponsitories.dart';

class StateLesdLoadImage extends StatelessWidget {
  final String idmessenger;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  StateLesdLoadImage({Key? key, required this.idmessenger}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (context) => ChatReponsitory(
            firebaseFirestore: this.firebaseFirestore,
            firebaseStorage: this.firebaseStorage),
        child: LoadAllImage(idmessenger: idmessenger));
  }
}

class LoadAllImage extends StatefulWidget {
  final String idmessenger;

  LoadAllImage({Key? key, required this.idmessenger}) : super(key: key);

  @override
  State<LoadAllImage> createState() => _LoadAllImageState(idmessenger);
}

class _LoadAllImageState extends State<LoadAllImage> {
  final String idmesenger;
  ChatReponsitory? chatReponsitory;

  _LoadAllImageState(this.idmesenger);
  @override
  void initState() {
    super.initState();
    chatReponsitory = context.read<ChatReponsitory>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatReponsitory!.getImageMessenger(groupChatId: idmesenger),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.docs;
            if (data != null) {
              if (data.length > 0) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      MessageChat messageChat =
                          MessageChat.fromDocument(snapshot.data!.docs[index]);
                      if (messageChat.type == 1)
                        return CachedNetworkImage(
                          imageUrl: messageChat.content,
                          fit: BoxFit.cover,
                        );
                      else {
                        return Text("");
                      }
                    });
              } else {
                return Center(
                  child: Text("oke"),
                );
              }
            } else {
              return SizedBox.shrink();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.grey,
              ),
            );
          }
        },
      ),
    );
  }
}
