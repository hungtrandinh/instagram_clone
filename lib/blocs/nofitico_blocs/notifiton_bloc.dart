import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_blocs.dart';
import 'package:social_app/blocs/nofitico_blocs/notifition_event.dart';
import 'package:social_app/blocs/nofitico_blocs/notifition_state.dart';
import 'package:social_app/repositories/notification.dart';

class NotifitionBloc extends Bloc<NotifitionEvent, NotifitionState> {
  final Notifition _notifition;
  final AppBloc _appBloc;
  NotifitionBloc({Notifition? notifition, AppBloc? appBloc})
      : _notifition = notifition!,
        _appBloc = appBloc!,
        super(NotifitionState.inital()) {
    on<NotifitionLoaded>(notifitionloaded);
    on<UpdateNotifition>(notifitionUpdate);
  }
  StreamSubscription? _streamSubscription;
  @override
  Future<void> close() {
    _streamSubscription!.cancel();
    return super.close();
  }

  Future<Stream<NotifitionState>?> notifitionloaded(
      NotifitionLoaded notifitionLoaded, Emitter emit) async {
    emit(state.copyWith(notificationStatus: NotificationStatus.initial));
    final userid = await _appBloc.state.user.id!;

    _streamSubscription =
        _notifition.getUserNotifications(userId: userid).listen((event) async {
      final data = await Future.wait(event);
      add(UpdateNotifition(listnotifition: data));
    });
  }

  Future<Stream<NotifitionState>?> notifitionUpdate(
      UpdateNotifition updateNotifition, Emitter emit) async {
    emit(state.copyWith(
        list: updateNotifition.listnotifition,
        notificationStatus: NotificationStatus.loaded));
  }
}
