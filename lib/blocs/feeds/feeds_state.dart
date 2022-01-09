import 'package:equatable/equatable.dart';
import 'package:social_app/model/post.dart';

class FeedState extends Equatable {
  final List<PostModel?> postList;
  final FeedStatus status;

  factory FeedState.initial() {
    return const FeedState(
      postList: [],
      status: FeedStatus.initial,
    );
  }

  FeedState copyWith({
    List<PostModel?>? postList,
    FeedStatus? status,
  }) {
    return new FeedState(
      postList: postList ?? this.postList,
      status: status ?? this.status,
    );
  }

  const FeedState({
    required this.postList,
    required this.status,
  });

  @override
  List<Object> get props => [postList, status];
}

enum FeedStatus { initial, loading, loaded, paginating, error }
