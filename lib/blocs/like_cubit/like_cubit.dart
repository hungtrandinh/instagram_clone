import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_blocs.dart';
import 'package:social_app/blocs/like_cubit/like_state.dart';
import 'package:social_app/model/post.dart';
import 'package:social_app/repositories/post_reponsitories.dart';

class LikeCubitt extends Cubit<Like_State> {
  final PostReponsitoris _repositoryProvider;
  final AppBloc _appBloc;
  LikeCubitt({PostReponsitoris? repositoryProvider, AppBloc? appBloc})
      : _repositoryProvider = repositoryProvider!,
        _appBloc = appBloc!,
        super(Like_State.intisial());

  void updateLikePost(Set<String> postId) {
    emit(state.copywith(
        timeLikePost: Set<String>.from(state.timeLikePost)..addAll(postId)));
  }

  void likePost({required PostModel postModel}) {
    _repositoryProvider.createLike(
        postModel: postModel, userId: _appBloc.state.user.id!);

    emit(state.copywith(
        timeLikePost: Set<String>.from(state.timeLikePost)..add(postModel.id!),
        likepost: Set<String>.from(state.likepost)..add(postModel.id!)));
  }

  void unlikePost(PostModel postModel) {
    _repositoryProvider.deleteLike(
        postId: postModel.id!, userId: _appBloc.state.user.id!);
    emit(state.copywith(
        timeLikePost: Set<String>.from(state.timeLikePost)
          ..remove(postModel.id!),
        likepost: Set<String>.from(state.likepost)..remove(postModel.id!)));
  }

  // void clearAllLikedPost() {
  //   emit(Like_State.intisial());
  // }
}
