import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/edit_profile_blocs/edit_profile_state.dart';
import 'package:social_app/blocs/profile_blocs/profile_bloc.dart';
import 'package:social_app/repositories/profile_reponsitories.dart';
import 'package:social_app/repositories/repositories.dart';

class EditProfileBloc extends Cubit<EditProfileState> {
  final SettingProvider _settingProvider;
  final EditProfile _editProfile;
  final AuthenticationRepository _repositoryProvider;

  EditProfileBloc(
      {required SettingProvider settingProvider,
      required AuthenticationRepository repositoryProvider,
      required EditProfile editProfile})
      : _settingProvider = settingProvider,
        _editProfile = editProfile,
        _repositoryProvider = repositoryProvider,
        super(EditProfileState.Initial()) {
    final user = _editProfile.state.myUser;
    emit(
      state.copyWith(
        username: user.name,
      ),
    );
  }

  void profileImageChanged(File image) async {
    emit(
      await state.copyWith(imagePath: image),
    );
  }

  void usernameChanged(String name) {
    emit(state.copyWith(username: name));
  }

  void aboumeChanged(String aboume) {
    emit(state.copyWith(aboutme: aboume));
  }

  Future<void> summit() async {
    var userdata = _editProfile.state.myUser;
    var imagePath = userdata.profilePictureURL;
    emit(state.copyWith(editProfileStatus: EditProfileStatus.submitting));
    imagePath =
        (await _settingProvider.uploadImageAndReturnURl(state.imagePath!));

    final userData = userdata.copyWith(
        aboutme: state.aboutme,
        profilePictureURL: imagePath,
        name: state.username);

    await _settingProvider.updateDataFirestore(
        "users", userdata.id!, userData.toJson());
    emit(state.copyWith(editProfileStatus: EditProfileStatus.success));
  }
}
