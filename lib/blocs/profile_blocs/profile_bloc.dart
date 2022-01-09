import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/profile_blocs/profile_event.dart';
import 'package:social_app/blocs/profile_blocs/profile_state.dart';

import 'package:social_app/repositories/post_reponsitories.dart';

import 'package:social_app/repositories/profile_reponsitories.dart';
import 'package:social_app/repositories/repositories.dart';

class EditProfile extends Bloc<EditProfileEvent, ProfileState> {
  final SettingProvider _settingProviderl;
  final AuthenticationRepository _authenticationRepository;
  final PostReponsitoris _postReponsitoris;
  StreamSubscription? _todosSubscription;
  final FirebaseAuth auth = FirebaseAuth.instance;

  EditProfile(this._settingProviderl, this._postReponsitoris,
      this._authenticationRepository)
      : super(ProfileState.initial()) {
    on<ChangeAvatarRequest>(ProfileData);
    on<ProfileFollowUserEvent>(Updatafolow);
    on<ProfileUnfollowUserEvent>(UnFolowing);
    on<LoadAllPost>(_UpdateAll);
  }
  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }

  void ProfileData(ChangeAvatarRequest changeAvatarRequest,
      Emitter<ProfileState> emit) async {
    User? user = auth.currentUser;
    final myId = user!.uid;
    try {
      final resul =
          await _settingProviderl.getCurentUser(changeAvatarRequest.id);
      _todosSubscription = await _postReponsitoris
          .getPostAll(id: changeAvatarRequest.id)
          .listen((event) async {
        final allPosts = await Future.wait(event);
        add(LoadAllPost(allPosts));
      });

      emit(state.copyWith(
        myUser: resul,
      ));
      final isfolowina = await _settingProviderl.isFollowing(
          userId: myId, otherUserId: state.myUser.id!);

      emit(state.copyWith(isFollowing: isfolowina));
      final getflow = await _settingProviderl.getflow(
          userId: myId, otherUserId: state.myUser.id!);
    } catch (e) {}
  }

  void _UpdateAll(LoadAllPost loadAllPost, Emitter<ProfileState> emit) {
    emit(ProfileState(
        post: loadAllPost.listPost,
        isFlowing: state.isFlowing,
        myUser: state.myUser));
  }

  void Updatafolow(
      ProfileFollowUserEvent profileFollowUserEvent, Emitter emit) async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    try {
      _settingProviderl.followUser(
          userId: userId, followUserId: state.myUser.id, postModel: state.post);
      final updateUser =
          state.myUser.copyWith(followers: state.myUser.followers! + 1);

      _authenticationRepository.updateCurrentUser(updateUser);

      emit(state.copyWith(myUser: updateUser, isFollowing: true));
    } catch (e) {}
  }

  void UnFolowing(
      ProfileUnfollowUserEvent profileUnfollowUserEvent, Emitter emit) async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    try {
      _settingProviderl.unfollowUser(
          userId: userId, unfollowUserId: state.myUser.id);
      final updateUser =
          state.myUser.copyWith(followers: state.myUser.followers! - 1);
      _authenticationRepository.updateCurrentUser(updateUser);

      emit(state.copyWith(myUser: updateUser, isFollowing: false));
    } catch (e) {}
  }
}
