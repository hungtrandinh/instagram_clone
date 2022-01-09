import 'package:equatable/equatable.dart';
import 'package:social_app/model/comment.dart';
import 'package:social_app/model/post.dart';

class CommentState extends Equatable {
  final List<CommentModel?> listcomment;
  final PostModel postModel;
  final StatusCommemt statusCommemt;

  CommentState(
      {required this.listcomment,
      required this.postModel,
      required this.statusCommemt});

  factory CommentState.intisial() {
    return CommentState(
        listcomment: [],
        postModel: PostModel.initial(),
        statusCommemt: StatusCommemt.initial);
  }

  CommentState copywith({
    List<CommentModel?>? listcomment,
    PostModel? postModel,
    StatusCommemt? statusCommemt,
  }) {
    return CommentState(
        listcomment: listcomment ?? this.listcomment,
        postModel: postModel ?? this.postModel,
        statusCommemt: statusCommemt ?? this.statusCommemt);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [listcomment, postModel, statusCommemt];
}

enum StatusCommemt { initial, loading, submitting, loaded, error }
