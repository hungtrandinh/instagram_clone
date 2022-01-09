import 'dart:io';

import 'package:equatable/equatable.dart';

class PostState extends Equatable {
  final File? postImage;
  final String caption;
  final StatusPost status;

  PostState(
      {required this.postImage, required this.caption, required this.status});
  factory PostState.initial() {
    return PostState(postImage: null, caption: "", status: StatusPost.initial);
  }
  PostState copyWith({File? postImage, String? caption, StatusPost? status}) {
    return new PostState(
      postImage: postImage ?? this.postImage,
      caption: caption ?? this.caption,
      status: status ?? this.status,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [postImage, caption, status];
}

enum StatusPost { initial, submitting, success, failure }
