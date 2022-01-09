import 'dart:io';

import 'package:equatable/equatable.dart';

class EditProfileState extends Equatable {
  String? image;
  String username;
  String aboutme;
  EditProfileStatus editProfileStatus;
  File? imagePath;

  EditProfileState(
      {required this.imagePath,
      required this.image,
      required this.username,
      required this.aboutme,
      required this.editProfileStatus});

  factory EditProfileState.Initial() {
    return EditProfileState(
        imagePath: null,
        image: null,
        username: "",
        aboutme: "",
        editProfileStatus: EditProfileStatus.initial);
  }
  EditProfileState copyWith(
      {String? image,
      String? username,
      String? aboutme,
      EditProfileStatus? editProfileStatus,
      File? imagePath}) {
    return EditProfileState(
        imagePath: imagePath ?? this.imagePath,
        image: image ?? this.image,
        username: username ?? this.username,
        aboutme: aboutme ?? this.aboutme,
        editProfileStatus: this.editProfileStatus);
  }

  @override
  List<Object?> get props =>
      [image, username, aboutme, editProfileStatus, imagePath];
}

enum EditProfileStatus { initial, submitting, success, error }
