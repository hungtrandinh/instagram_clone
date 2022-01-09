import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/model/user.dart';

class PostModel extends Equatable {
  const PostModel({
    //firebase automatically create id
    this.id,
    required this.caption,
    required this.imageUrl,
    required this.author,
    required this.likes,
    required this.dateTime,
  });

  final String? id;
  final String caption;
  final String imageUrl;
  final MyUser author;
  final int likes;
  final DateTime dateTime;

  factory PostModel.initial() {
    return PostModel(
      caption: "",
      imageUrl: "",
      author: MyUser.empty,
      likes: 0,
      dateTime: DateTime.now(),
    );
  }

  PostModel copyWith({
    String? id,
    String? caption,
    String? imageUrl,
    MyUser? author,
    int? likes,
    DateTime? dateTime,
  }) {
    return new PostModel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      likes: likes ?? this.likes,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  @override
  List<Object> get props => [caption, imageUrl, author, likes, dateTime];

  Map<String, dynamic> toDocuments() {
    final authorDocsRef =
        FirebaseFirestore.instance.collection("users").doc(author.id);
    return {
      // 'id': id,
      // 'id': FirebaseFirestore.instance.collection("post").doc().get(),
      'caption': caption,
      'imageUrl': imageUrl,
      'author': authorDocsRef,
      'likes': likes,
      'dateTime': Timestamp.fromDate(dateTime),
    };
  }

  PostModel.fromjson(Map<String, dynamic> doc)
      : id = '1',
        caption = doc["caption"] ?? "a",
        imageUrl = doc["imageUrl"] ?? "a",
        author = MyUser.empty,
        likes = (doc["likes"] ?? 0).toInt(),
        dateTime = (doc["dateTime"] as Timestamp).toDate();

//  we need to convert document reference to userModel so we don't use fromDocument instead following:

  static Future<PostModel?> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) {
      return null;
    }

    final authorRef = doc["author"] as DocumentReference;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return PostModel(
          id: doc.id,
          caption: doc["caption"] ?? "",
          imageUrl: doc["imageUrl"] ?? "",
          author: MyUser.fromDocument(authorDoc),
          likes: (doc["likes"] ?? 0).toInt(),
          dateTime: (doc["dateTime"] as Timestamp).toDate(),
        );
      }
    }
    return null;
  }
}
