import 'package:equatable/equatable.dart';

class Like_State extends Equatable {
  final Set<String> likepost;
  final Set<String> timeLikePost;

  factory Like_State.intisial() {
    return Like_State(likepost: {}, timeLikePost: {});
  }

  Like_State({required this.likepost, required this.timeLikePost});

  Like_State copywith({Set<String>? likepost, Set<String>? timeLikePost}) {
    return Like_State(
        likepost: likepost ?? this.likepost,
        timeLikePost: timeLikePost ?? this.timeLikePost);
  }

  @override
  List<Object?> get props => [likepost, timeLikePost];
}
