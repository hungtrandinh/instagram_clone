import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/api_image_blocs/api_image_state.dart';
import 'package:social_app/repositories/apiimage.dart';

class CubitImage extends Cubit<StateImage> {
  final Api _api;
  CubitImage({required Api api})
      : _api = api,
        super(StateImage.intisial());

  Future<void> seachImage({required String query}) async {
    emit(state.copyWith(statusApp: ImageStatusApp.intisial));
    try {
      final getImage = await _api.getApiImage(query: query);
      emit(state.copyWith(statusApp: ImageStatusApp.success, raw: getImage));
    } catch (e) {}
  }

  Future<void> dowloadImage({required String url}) async {
    emit(state.copyWith(statusApp: ImageStatusApp.dowload));
    try {
      final dowloadimage = await _api.dowlaodImage(url: url);
      emit(state.copyWith(statusApp: ImageStatusApp.done));
    } catch (e) {}
  }
}
