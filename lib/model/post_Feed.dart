import 'package:equatable/equatable.dart';
import 'package:social_app/model/post.dart';

class PosdFeed extends Equatable {
  final List<PostModel?> post;

  PosdFeed(this.post);
  PosdFeed.fromjson(Map<String, dynamic> json)
      : post = List<PostModel>.from(
            json["data"].map((x) => PostModel.fromjson(x)));

  @override
  // TODO: implement props
  List<Object?> get props => [post];
}
