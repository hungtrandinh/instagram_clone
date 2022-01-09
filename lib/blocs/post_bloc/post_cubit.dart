import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:social_app/blocs/post_bloc/post_state.dart';
import 'package:social_app/model/post.dart';
import 'package:social_app/model/user.dart';
import 'package:social_app/repositories/post_reponsitories.dart';

class PostCubit extends Cubit<PostState> {
  final PostReponsitoris _postReponsitoris;

  PostCubit({
    required PostReponsitoris postReponsitoris,
  })  : _postReponsitoris = postReponsitoris,
        super(PostState.initial());

  void PostImageChange(File? file) {
    emit(state.copyWith(postImage: file, status: StatusPost.initial));
  }

  void CaptionChange(String? caption) {
    emit(state.copyWith(caption: caption, status: StatusPost.initial));
  }

  void reset() {
    emit(PostState.initial());
  }

  void deletepost({required String equa}) {
    final delete = _postReponsitoris.deletePost(equa: equa);
  }

  void summit() async {
    emit(state.copyWith(status: StatusPost.submitting));
    User? user = FirebaseAuth.instance.currentUser;
    String udi = user!.uid;
    final author = MyUser.empty.copyWith(id: udi);
    final postImageUrl = await _postReponsitoris.uploadPostImageAndGiveUrl(
        image: state.postImage!);
    final post = PostModel(
      caption: state.caption,
      imageUrl: postImageUrl,
      author: author,
      likes: 0,
      dateTime: DateTime.now(),
    );
    _postReponsitoris.createPost(postModel: post, id: udi);
    emit(state.copyWith(status: StatusPost.success));
  }
}
