import 'package:equatable/equatable.dart';
import 'package:social_app/model/nofiticol.dart';

class NotifitionState extends Equatable {
  final List<NotificationModel?> list;
  final NotificationStatus notificationStatus;

  NotifitionState({required this.list, required this.notificationStatus});
  @override
  List<Object?> get props => [list, notificationStatus];

  factory NotifitionState.inital() {
    return NotifitionState(
        list: [], notificationStatus: NotificationStatus.initial);
  }

  NotifitionState copyWith(
      {List<NotificationModel?>? list,
      NotificationStatus? notificationStatus}) {
    return NotifitionState(
        list: list ?? this.list,
        notificationStatus: notificationStatus ?? this.notificationStatus);
  }
}

enum NotificationStatus { initial, loading, loaded, error }
