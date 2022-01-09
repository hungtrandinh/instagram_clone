import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/app_login_blocs/app_login_blocs.dart';
import 'package:social_app/blocs/seach_cubit/seach_state.dart';
import 'package:social_app/repositories/profile_reponsitories.dart';

class SearchCubit extends Cubit<SearchState> {
  final AppBloc _appBloc;
  final SettingProvider _settingProvider;

  SearchCubit({AppBloc? appBloc, SettingProvider? settingProvider})
      : _appBloc = appBloc!,
        _settingProvider = settingProvider!,
        super(SearchState.initial());

  void getUserSeach({required String name}) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final dataUser = await _settingProvider.searchUsers(query: name);
      emit(state.copyWith(userList: dataUser, status: SearchStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.error));
      print(e);
    }
  }

  void clearSeach() {
    emit(state.copyWith(userList: [], status: SearchStatus.initial));
  }
}
