import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/model/user.dart';

class CommentModel extends Equatable {
  final String id;
  final String postId;
  final String content;
  final MyUser author;
  final DateTime dateTime;

  CommentModel(
      {required this.id,
      required this.postId,
      required this.content,
      required this.author,
      required this.dateTime});
  @override
  // TODO: implement props
  List<Object?> get props => [id, postId, content, author, dateTime];
  static Future<CommentModel?> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) {
      return null;
    }
    final data = doc;
    final authorRef = data["author"] as DocumentReference;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return CommentModel(
          id: doc.id,
          postId: data["postId"] ?? "",
          content: data["content"] ?? "",
          author: MyUser.fromDocument(authorDoc),
          dateTime: (data["dateTime"] as Timestamp).toDate(),
        );
      }
    }
    return null;
  }

  factory CommentModel.initial() {
    return CommentModel(
      postId: "",
      content: "",
      author: MyUser.empty,
      id: "",
      dateTime: DateTime.now(),
    );
  }

  CommentModel copyWith(
      {String? content,
      String? id,
      String? postId,
      MyUser? author,
      DateTime? dateTime}) {
    return CommentModel(
        id: id ?? this.id,
        postId: postId ?? this.id,
        content: content ?? this.content,
        author: author ?? this.author,
        dateTime: dateTime ?? this.dateTime);
  }

  Map<String, dynamic> toDocuments() {
    final authorId =
        FirebaseFirestore.instance.collection("users").doc(author.id);
    return {
      'postId': postId,
      'content': content,
      'author': authorId,
      'dateTime': Timestamp.fromDate(dateTime),
    };
  }
}
