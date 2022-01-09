import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_blocs.dart';
import 'package:social_app/blocs/comment_blocs/comment_event.dart';
import 'package:social_app/blocs/comment_blocs/comment_state.dart';
import 'package:social_app/model/comment.dart';
import 'package:social_app/model/user.dart';
import 'package:social_app/repositories/post_reponsitories.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final AppBloc _appBloc;
  final PostReponsitoris _postReponsitoris;

  CommentBloc(
      {AppBloc? appBloc,
      PostReponsitoris? postReponsitoris,
      StreamSubscription? streamSubscription})
      : _appBloc = appBloc!,
        _postReponsitoris = postReponsitoris!,
        super(CommentState.intisial()) {
    on<FetchCommentEvent>(getComment);
    on<PostCommentsEvent>(postComment);
    on<UpdateCommentsEvent>(updateComment);
  }

  StreamSubscription? _commentSubscription;

  Future<void> close() {
    _commentSubscription!.cancel();
    return super.close();
  }

  Future<Stream<CommentModel>?> getComment(
      FetchCommentEvent fetchCommentEvent, Emitter emit) async {
    emit(state.copywith(statusCommemt: StatusCommemt.loading));

    _commentSubscription = _postReponsitoris
        .getCommentPost(id: fetchCommentEvent.postModel.id!)
        .listen((comment) async {
      final list = await Future.wait(comment);
      add(UpdateCommentsEvent(commentList: list));
    });
    emit(state.copywith(
        statusCommemt: StatusCommemt.loaded,
        postModel: fetchCommentEvent.postModel));
  }

  Future<Stream<CommentModel>?> postComment(
      PostCommentsEvent postCommentsEvent, Emitter emit) async {
    emit(state.copywith(statusCommemt: StatusCommemt.submitting));
    MyUser authorId = MyUser.empty.copyWith(id: _appBloc.state.user.id!);
    final comment = CommentModel(
        id: _appBloc.state.user.id!,
        postId: state.postModel.id!,
        content: postCommentsEvent.content,
        author: authorId,
        dateTime: DateTime.now());

    await _postReponsitoris.createComent(
        postModel: state.postModel, commentModel: comment);
    emit(state.copywith(statusCommemt: StatusCommemt.loaded));
  }

  Future<Stream<CommentState>?> updateComment(
      UpdateCommentsEvent updateCommentsEvent, Emitter emit) async {
    //emit(state.copywith(statusCommemt: StatusCommemt.loading));
    try {
      emit(state.copywith(listcomment: updateCommentsEvent.commentList));
    } on FirebaseException catch (e) {
      emit(state.copywith(statusCommemt: StatusCommemt.error));
      print(e);
    } catch (e) {
      emit(state.copywith(statusCommemt: StatusCommemt.error));
    }
  }
}
