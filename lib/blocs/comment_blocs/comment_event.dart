import 'package:equatable/equatable.dart';
import 'package:social_app/model/comment.dart';
import 'package:social_app/model/post.dart';

abstract class CommentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCommentEvent extends CommentEvent {
  final PostModel postModel;

  FetchCommentEvent({
    required this.postModel,
  });

  @override
  List<Object> get props => [postModel];
}

class UpdateCommentsEvent extends CommentEvent {
  final List<CommentModel?> commentList;

  UpdateCommentsEvent({required this.commentList});
  @override
  List<Object> get props => [commentList];
}

class PostCommentsEvent extends CommentEvent {
  final String content;

  PostCommentsEvent({required this.content});
  @override
  List<Object> get props => [content];
}
