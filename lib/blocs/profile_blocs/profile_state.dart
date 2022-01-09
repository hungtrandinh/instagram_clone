import 'package:equatable/equatable.dart';
import 'package:social_app/model/post.dart';
import 'package:social_app/model/user.dart';

class ProfileState extends Equatable {
  final MyUser myUser;
  final List<PostModel?>? post;
  final bool isFlowing;

  ProfileState(
      {required this.post, required this.isFlowing, required this.myUser});

  @override
  // TODO: implement props
  List<Object?> get props => [myUser, post, isFlowing];

  ProfileState copyWith(
      {MyUser? myUser, List<PostModel>? postModel, bool? isFollowing}) {
    return ProfileState(
        myUser: myUser ?? this.myUser,
        post: postModel ?? this.post,
        isFlowing: isFollowing ?? this.isFlowing);
  }

  factory ProfileState.initial() {
    return ProfileState(myUser: MyUser.empty, post: [], isFlowing: false);
  }
}
