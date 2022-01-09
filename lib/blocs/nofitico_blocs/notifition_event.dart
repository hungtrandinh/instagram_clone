import 'package:equatable/equatable.dart';
import 'package:social_app/model/nofiticol.dart';

abstract class NotifitionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateNotifition extends NotifitionEvent {
  final List<NotificationModel?> listnotifition;

  UpdateNotifition({required this.listnotifition});

  @override
  List<Object?> get props => [listnotifition];
}

class NotifitionLoaded extends NotifitionEvent {}
