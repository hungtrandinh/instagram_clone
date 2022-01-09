import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/values/app_assets_icons.dart';

class MyUser extends Equatable {
  final String? aboutme;
  final String? name;
  final String? email;
  final String? id;
  final int? followers;
  final int? following;
  final String? profilePictureURL;

  const MyUser(
      {this.profilePictureURL,
      this.name,
      this.aboutme,
      this.email,
      this.followers,
      this.following,
      required this.id});
  static const empty = MyUser(id: '');
  bool get isEmpty => this == MyUser.empty;
  bool get isNotEmpty => this != MyUser.empty;

  @override
  List<Object?> get props => [name, email, id];
  Map<String, dynamic> toDocument() {
    return {
      'username': name,
      'email': email,
      'imageUrl': profilePictureURL,
      'followers': followers,
      'following': following
    };
  }

  factory MyUser.fromDocument(DocumentSnapshot doc) {
    String? profilePictureURL = null;

    String gmail = "tdhung.18it4";
    String nickname = "hung";
    int following = 0;
    int followers = 0;
    return MyUser(
      followers: doc["followers"] ?? followers,
      following: doc["following"] ?? following,
      id: doc.id,
      email: doc["email"] ?? gmail,
      name: doc["firstName"] ?? nickname,
      profilePictureURL: doc["profilePictureURL"] ?? profilePictureURL,
    );
  }

  static MyUser fromJson(Map<String, dynamic> parsedJson) {
    return MyUser(
      followers: parsedJson["followers"] ?? 0,
      following: parsedJson["following"] ?? 0,
      email: parsedJson['email'] ?? '',
      name: parsedJson['firstName'] ?? '',
      id: parsedJson['id'] ?? parsedJson['userID'] ?? '',
      profilePictureURL: parsedJson['profilePictureURL'] ?? null,
    );
  }

  MyUser copyWith(
      {int? following,
      int? followers,
      String? email,
      String? aboutme,
      String? name,
      String? id,
      String? profilePictureURL}) {
    return MyUser(
        following: following ?? this.following,
        followers: followers ?? this.followers,
        aboutme: aboutme ?? this.aboutme,
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        profilePictureURL: profilePictureURL ?? this.profilePictureURL);
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email ?? " hungne",
      'firstName': name ?? "Trần Đình Hùng",
      'id': id ?? "123",
      'profilePictureURL': profilePictureURL ?? null,
      'followers': followers ?? 0,
      'following': following ?? 0,
    };
  }
}
