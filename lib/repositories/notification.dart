import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/model/nofiticol.dart';
import 'package:social_app/values/positisionname.dart';

class Notifition {
  final FirebaseFirestore _firebaseFirestore;

  Notifition({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Future<NotificationModel?>>> getUserNotifications(
      {required String userId}) {
    final notification = FirebaseConstants.notifications;
    final userNotifications = FirebaseConstants.userNotifications;
    final snapshots = _firebaseFirestore
        .collection(notification)
        .doc(userId)
        .collection(userNotifications)
        .orderBy("dateTime", descending: true)
        .snapshots();
    // print("snapshots $snapshots");

    return snapshots.map(
      (querySnaps) => querySnaps.docs.map((queryDocSnap) {
        // print("queryDocSnap $queryDocSnap");
        return NotificationModel.fromDocument(queryDocSnap);
      }).toList(),
    );
  }
}
