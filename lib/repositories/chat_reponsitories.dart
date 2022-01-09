import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_app/model/messenger_chat.dart';

class ChatReponsitory {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ChatReponsitory(
      {required this.firebaseStorage, required this.firebaseFirestore});
  void seenMessenger(String content, int type, String groupChatID,
      String peerId, String currenUserId) {
    DocumentReference documentReference = firebaseFirestore
        .collection("messenger")
        .doc(groupChatID)
        .collection(groupChatID)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    MessageChat messageChat = MessageChat(
      idFrom: currenUserId,
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }

  UploadTask uploadfile(File fileimage, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(fileimage);
    return uploadTask;
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath,
      Map<String, dynamic> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getMessenger(String groupChatId, int limit) {
    return firebaseFirestore
        .collection("messenger")
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy("timestamp", descending: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot> getImageMessenger({required String groupChatId}) {
    return firebaseFirestore
        .collection("messenger")
        .doc(groupChatId)
        .collection(groupChatId)
        .where("type", isEqualTo: 1)
        .snapshots();
  }
}
