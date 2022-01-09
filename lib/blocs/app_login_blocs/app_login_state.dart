import 'package:equatable/equatable.dart';
import 'package:social_app/model/user.dart';

enum AppStatus { authenticated, unauthenticated, firstRun }

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = MyUser.empty,
  });
  const AppState.onboaring() : this._(status: AppStatus.firstRun);
  const AppState.authenticated(MyUser user)
      : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final MyUser user;

  @override
  List<Object> get props => [status, user];
}
