import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_blocs.dart';
import 'package:social_app/blocs/nofitico_blocs/notifition_event.dart';
import 'package:social_app/blocs/nofitico_blocs/notifition_state.dart';
import 'package:social_app/blocs/nofitico_blocs/notifiton_bloc.dart';
import 'package:social_app/repositories/notification.dart';
import 'package:social_app/values/app_assets_colors.dart';
import 'package:social_app/widgets/noffitionwidet.dart';

class NotifitionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotifitionBloc>(
      create: (context) {
        return NotifitionBloc(
            notifition: context.read<Notifition>(),
            appBloc: context.read<AppBloc>())
          ..add(NotifitionLoaded());
      },
      child: MaterialApp(
          home: Scaffold(
              backgroundColor: ColorConstants.backgroucolor,
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_rounded)),
                backgroundColor: ColorConstants.backgroucolor,
                title: Text("Thong Bao"),
              ),
              body: NotifitionWidget())),
    );
  }
}

class NotifitionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotifitionBloc, NotifitionState>(
        builder: (context, state) {
          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 60),
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return NotificationTile(notificationModel: state.list[index]!);
              });
        },
        listener: (context, state) {});
  }
}
