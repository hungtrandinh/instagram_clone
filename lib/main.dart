import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/api_image_blocs/api_image_bloc.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_state.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:social_app/blocs/edit_profile_blocs/edit_profile_bloc.dart';
import 'package:social_app/blocs/like_cubit/like_cubit.dart';
import 'package:social_app/blocs/nofitico_blocs/notifiton_bloc.dart';
import 'package:social_app/blocs/post_bloc/post_cubit.dart';
import 'package:social_app/blocs/seach_cubit/seach_cubit.dart';
import 'package:social_app/repositories/apiimage.dart';

import 'package:social_app/repositories/notification.dart';
import 'package:social_app/repositories/post_reponsitories.dart';
import 'package:social_app/repositories/profile_reponsitories.dart';
import 'package:social_app/repositories/repositories.dart';
import 'package:social_app/router/router_login.dart';
import 'blocs/app_login_blocs/app_login_blocs.dart';
import 'blocs/bloc_obersever.dart';
import 'blocs/profile_blocs/profile_bloc.dart';

void main() async {
  Bloc.observer = AppObersever();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase?.initializeApp();
  final notifition = Notifition();
  final post = PostReponsitoris();
  final editReponsitory = SettingProvider();
  final authenticationRepository = AuthenticationRepository();
  final api = Api();
  await authenticationRepository.user.first;
  runApp(MyApp(
    authenticationRepository: authenticationRepository,
    settingProvider: editReponsitory,
    postReponsitoris: post,
    notifition: notifition,
    api: api,
  ));
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository? _authenticationRepository;
  final SettingProvider? _settingProvider;
  final PostReponsitoris? _postReponsitoris;
  final Notifition? _notifition;
  final Api? _api;

  const MyApp(
      {Key? key,
      required Api api,
      required Notifition notifition,
      required PostReponsitoris postReponsitoris,
      required AuthenticationRepository authenticationRepository,
      required SettingProvider settingProvider})
      : _authenticationRepository = authenticationRepository,
        _settingProvider = settingProvider,
        _postReponsitoris = postReponsitoris,
        _notifition = notifition,
        _api = api,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<Api>(create: (_) => Api()),
          RepositoryProvider<PostReponsitoris>(
              create: (_) => PostReponsitoris()),
          RepositoryProvider<AuthenticationRepository>(
              create: (_) => AuthenticationRepository()),
          RepositoryProvider<SettingProvider>(
            create: (_) => SettingProvider(),
          ),
          RepositoryProvider<Notifition>(
            create: (_) => Notifition(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => CubitImage(api: _api!)),
            BlocProvider(
              create: (context) => AppBloc(
                  authenticationRepository: _authenticationRepository!,
                  settingProvider: _settingProvider!),
            ),
            BlocProvider(
                create: (context) => EditProfile(_settingProvider!,
                    _postReponsitoris!, _authenticationRepository!)),
            BlocProvider(
                create: (context) => EditProfileBloc(
                    settingProvider: _settingProvider!,
                    repositoryProvider: _authenticationRepository!,
                    editProfile: EditProfile(_settingProvider!,
                        _postReponsitoris!, _authenticationRepository!))),
            BlocProvider(
                create: (context) => PostCubit(
                      postReponsitoris: _postReponsitoris!,
                    )),
            BlocProvider(
                create: (context) => LikeCubitt(
                    repositoryProvider: _postReponsitoris!,
                    appBloc: context.read<AppBloc>())),
            BlocProvider(
                create: (context) => NotifitionBloc(
                    notifition: _notifition!,
                    appBloc: context.read<AppBloc>())),
            BlocProvider(
                create: (context) => SearchCubit(
                    settingProvider: _settingProvider,
                    appBloc: context.read<AppBloc>()))
          ],
          child: AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) {
          return bloc.state.status;
        }),
        onGeneratePages: onGenerateAppViewPages,
      )),
    );
  }
}
