import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_blocs.dart';
import 'package:social_app/blocs/feeds/feeds_event.dart';
import 'package:social_app/blocs/feeds/feeds_state.dart';
import 'package:social_app/blocs/like_cubit/like_cubit.dart';
import 'package:social_app/repositories/post_reponsitories.dart';

class Post_Feed_Bloc extends Bloc<PostEvent, FeedState> {
  final PostReponsitoris _postReponsitoris;
  StreamSubscription? _todosSubscription;
  final LikeCubitt _likeCubitt;
  final AppBloc _appBloc;

  Post_Feed_Bloc(
      {PostReponsitoris? postReponsitoris,
      LikeCubitt? likeCubitt,
      AppBloc? appBloc})
      : _postReponsitoris = postReponsitoris!,
        _likeCubitt = likeCubitt!,
        _appBloc = appBloc!,
        super(FeedState.initial()) {
    on<Changerequest>(getPostFeed);
  }
  Future<Stream<FeedState>?> getPostFeed(
      Changerequest changerequest, Emitter emit) async {
    // emit(state.copyWith(status: FeedStatus.loading, postList: []));
    final loadPost =
        await _postReponsitoris.getUserFeed(userId: _appBloc.state.user.id!);

    // _likeCubitt.clearAllLikedPost();

    final updatelike = await _postReponsitoris.getLikedPostIds(
        userId: _appBloc.state.user.id!, postModel: loadPost);

    _likeCubitt.updateLikePost(updatelike);
    emit(state.copyWith(postList: loadPost, status: FeedStatus.loaded));
  }
}
