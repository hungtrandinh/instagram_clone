import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_event.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_state.dart';
import 'package:social_app/model/user.dart';
import 'package:social_app/repositories/profile_reponsitories.dart';
import 'package:social_app/repositories/repositories.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(
      {required AuthenticationRepository authenticationRepository,
      required SettingProvider settingProvider})
      : _authenticationRepository = authenticationRepository,
        _settingProvider = settingProvider,
        super(authenticationRepository.currentUser.isNotEmpty
            ? AppState.authenticated(authenticationRepository.currentUser)
            : const AppState.unauthenticated()) {
    on<UserChanger>(_onUserChanged);
    on<UserLogOut>(_onLogoutRequested);
    _streamSubscription = authenticationRepository.user.listen(
      (user) => add((UserChanger(user))),
    );
  }
  final SettingProvider _settingProvider;
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<MyUser> _streamSubscription;
  void _onUserChanged(UserChanger event, Emitter<AppState> emit) {
    emit(event.user.isNotEmpty
        ? AppState.authenticated(event.user)
        : const AppState.unauthenticated());
  }

  void _onLogoutRequested(UserLogOut event, Emitter<AppState> emit) {
    return unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
