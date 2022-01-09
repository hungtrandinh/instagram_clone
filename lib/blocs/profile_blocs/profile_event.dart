import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:social_app/model/post.dart';

abstract class EditProfileEvent extends Equatable {}

class ChangeAvatarRequest extends EditProfileEvent {
  final String id;

  ChangeAvatarRequest(this.id);
  @override
  List<Object?> get props => [id];
}

class LoadAllPost extends EditProfileEvent {
  final List<PostModel?> listPost;

  LoadAllPost(this.listPost);
  @override
  List<Object?> get props => [listPost];
}

class ProfileFollowUserEvent extends EditProfileEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProfileUnfollowUserEvent extends EditProfileEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
