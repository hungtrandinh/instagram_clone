import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/model/post.dart';
import 'package:social_app/model/user.dart';
import 'package:social_app/values/positisionname.dart';

class NotificationModel extends Equatable {
  final String? id;
  final NotificationType? notificationType;
  final MyUser? fromUser;
  final PostModel? postModel;
  final DateTime? dateTime;

  const NotificationModel({
    required this.id,
    required this.notificationType,
    required this.fromUser,
    this.postModel,
    required this.dateTime,
  });

  Map<String, dynamic> toDocument() {
    final _firebaseInstance = FirebaseFirestore.instance;
    final notificationEnumType = EnumToString.convertToString(notificationType);
    final fromUserDocRef =
        _firebaseInstance.collection(FirebaseConstants.users).doc(fromUser!.id);
    final postDocRef = _firebaseInstance
        .collection(FirebaseConstants.posts)
        .doc(postModel!.id);

    return {
      'NotificationType': notificationEnumType,
      'fromUser': fromUserDocRef,
      'post': postModel != null ? postDocRef : null,
      'dateTime': Timestamp.fromDate(dateTime!),
    };
  }

  static Future<NotificationModel?> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) {}
    // final data = doc.data();
    final notificationEnumType = EnumToString.fromString(
        NotificationType.values, doc["NotificationType"]);
    final fromUserDocRef = doc["fromUser"] as DocumentReference;
    final postDocRef = doc["post"] as DocumentReference;

    // print("User Ref ${data["post"]}");
    if (fromUserDocRef != null) {
      final fromUserDoc = await fromUserDocRef.get();
      if (postDocRef != null) {
        final postDoc = await postDocRef.get();
        if (postDoc.exists) {
          // print("User Ref Post ${data["fromUser"]}");
          return NotificationModel(
            id: doc.id,
            notificationType: notificationEnumType,
            fromUser: MyUser.fromDocument(fromUserDoc),
            postModel: await PostModel.fromDocument(postDoc),
            dateTime: (doc["dateTime"] as Timestamp).toDate(),
          );
        }
      } else {
        return NotificationModel(
          id: doc.id,
          notificationType: notificationEnumType,
          fromUser: MyUser.fromDocument(fromUserDoc),
          dateTime: (doc["dateTime"] as Timestamp).toDate(),
        );
      }
    }
    return null;
  }

  NotificationModel copyWith({
    String? id,
    NotificationType? notificationType,
    MyUser? fromUser,
    PostModel? postModel,
    DateTime? dateTime,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      notificationType: notificationType ?? this.notificationType,
      fromUser: fromUser ?? this.fromUser,
      postModel: postModel ?? this.postModel,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  @override
  List<Object> get props =>
      [id!, notificationType!, fromUser!, postModel!, dateTime!];
}

enum NotificationType { like, comment, follow, unfollow }
