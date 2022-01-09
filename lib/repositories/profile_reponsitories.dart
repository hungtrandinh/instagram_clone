import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_app/model/nofiticol.dart';
import 'package:social_app/model/post.dart';

import 'package:social_app/model/user.dart';
import 'package:social_app/values/positisionname.dart';

class SettingProvider {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final PostModel _postModel;
  SettingProvider({
    FirebaseFirestore? firebaseFirestore,
    FirebaseStorage? firebaseStorage,
    PostModel? postModel,
  })  : _postModel = postModel ?? PostModel.initial(),
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<List<MyUser>> searchUsers({required String query}) async {
    final userCollection = FirebaseConstants.users;
    final userSnap = await firebaseFirestore
        .collection('users')
        .where("firstName", isEqualTo: query)
        .get();
    return userSnap.docs
        .map((queryDocSnap) => MyUser.fromDocument(queryDocSnap))
        .toList();
  }

  void followUser(
      {String? userId,
      String? followUserId,
      List<PostModel?>? postModel}) async {
    final followers = FirebaseConstants.followers;
    final following = FirebaseConstants.following;
    final userFollowers = FirebaseConstants.userFollowers;
    final userFollowing = FirebaseConstants.userFollowing;

    /// add followUser to user's collection
    await firebaseFirestore
        .collection(following)
        .doc(userId)
        .collection(userFollowing)
        .doc(followUserId)
        .set({});

    /// add current user to followUser's userFollowers.
    await firebaseFirestore
        .collection(followers)
        .doc(followUserId)
        .collection(userFollowers)
        .doc(userId)
        .set({});

    final notification = NotificationModel(
        id: userId,
        notificationType: NotificationType.follow,
        fromUser: MyUser.empty.copyWith(id: userId),
        dateTime: DateTime.now(),
        postModel: null);

    //  adding in firebase firestore notifications collection
    //  whose id is this and we put their uid in notifications collection
    final notificationsCol = FirebaseConstants.notifications;
    final userNotificationsCol = FirebaseConstants.userNotifications;
    firebaseFirestore
        .collection(notificationsCol)
        .doc(followUserId)
        .collection(userNotificationsCol)
        .add(
          notification.toDocument(),
        );
    // List yourItemList = [];
    // for (int i = 0; i < postModel!.length; i++)
    //   yourItemList.add({
    //     "caption": postModel.toList()[i]!.caption,
    //     "dateTime": postModel.toList()[i]!.dateTime,
    //     "imageUrl": postModel.toList()[i]!.imageUrl,
    //     "likes": postModel.toList()[i]!.likes
    //   });
    // await firebaseFirestore
    //     .collection("Post_Feed")
    //     .doc(userId)
    //     .collection("items")
    //     .doc(followUserId)
    //     .set({"data": FieldValue.arrayUnion(yourItemList)});
  }

  void unfollowUser({String? userId, String? unfollowUserId}) async {
    final followers = FirebaseConstants.followers;
    final following = FirebaseConstants.following;
    final userFollowers = FirebaseConstants.userFollowers;
    final userFollowing = FirebaseConstants.userFollowing;

    /// remove unfollowing user from user's userFollowing
    await firebaseFirestore
        .collection(following)
        .doc(userId)
        .collection(userFollowing)
        .doc(unfollowUserId)
        .delete();

    /// remove user from unfollowUser's usersFollowers.
    await firebaseFirestore
        .collection(followers)
        .doc(unfollowUserId)
        .collection(userFollowers)
        .doc(userId)
        .delete();

    final notification = NotificationModel(
        notificationType: NotificationType.unfollow,
        fromUser: MyUser.empty.copyWith(id: userId),
        dateTime: DateTime.now(),
        id: userId,
        postModel: null);

    //  adding in firebase firestore notifications collection
    //  whose id is this and we put their uid in notifications collection
    final notificationsCol = FirebaseConstants.notifications;
    final userNotificationsCol = FirebaseConstants.userNotifications;
    firebaseFirestore
        .collection(notificationsCol)
        .doc(unfollowUserId)
        .collection(userNotificationsCol)
        .add(
          notification.toDocument(),
        );
  }

  Future<bool> isFollowing(
      {required String userId, required String otherUserId}) async {
    // final followers = FirebaseCollectionConstants.followers;
    final following = FirebaseConstants.following;
    final userFollowing = FirebaseConstants.userFollowing;

    final otherUserDoc = await firebaseFirestore
        .collection(following)
        .doc(userId)
        .collection(userFollowing)
        .doc(otherUserId)
        .get();
    return otherUserDoc.exists;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getflow(
      {required String userId, required String otherUserId}) async {
    // final followers = FirebaseCollectionConstants.followers;
    final following = FirebaseConstants.following;
    final userFollowing = FirebaseConstants.userFollowing;

    final otherUserDoc = await firebaseFirestore
        .collection(following)
        .doc(userId)
        .collection(userFollowing)
        .get();
    return otherUserDoc.docs;
  }

  Future<MyUser?> getCurentUser(String id) async {
    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await firebaseFirestore.collection('users').doc(id).get();
    if (userDocument.data() != null && userDocument.exists) {
      return MyUser.fromJson(userDocument.data()!);
    } else {
      return null;
    }
  }

  UploadTask uploadFile(File image, String fileName) {
    User? user = FirebaseAuth.instance.currentUser;
    String udi = user!.uid;
    Reference reference = firebaseStorage.ref("avata/$udi/").child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<String?> uploadImageAndReturnURl(File image) async {
    User? user = FirebaseAuth.instance.currentUser;
    String udi = user!.uid;

    final downloadUrl = await firebaseStorage
        .ref("avata/$udi/")
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
    return downloadUrl;
  }

  Future<void> updateDataFirestore(
      String collectionPath, String path, Map<String, dynamic> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }

  Stream<List<MyUser>> getAllFirebaseUsers() {
    final users = FirebaseConstants.users;
    return firebaseFirestore.collection(users).snapshots().map(
          (querySnap) => querySnap.docs
              .map(
                (queryDocSnap) => MyUser.fromDocument(queryDocSnap),
              )
              .toList(),
        );
  }
}
