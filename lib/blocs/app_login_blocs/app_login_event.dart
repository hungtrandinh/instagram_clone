import 'package:equatable/equatable.dart';

import 'package:flutter/foundation.dart';
import 'package:social_app/model/user.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
  @override
  List<Object> get props => [];
}

class UserLogOut extends AppEvent {}

class UserChanger extends AppEvent {
  @visibleForTesting
  const UserChanger(this.user);
  final MyUser user;
  @override
  List<Object> get props => [user];
}
