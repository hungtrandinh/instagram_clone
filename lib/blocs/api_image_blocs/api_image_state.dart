import 'package:equatable/equatable.dart';
import 'package:social_app/model/imageApi.dart';

class StateImage extends Equatable {
  final GetApiAll? raw;
  final ImageStatusApp statusApp;
  StateImage({required this.raw, required this.statusApp});

  factory StateImage.intisial() {
    return StateImage(raw: null, statusApp: ImageStatusApp.intisial);
  }
  StateImage copyWith({
    GetApiAll? raw,
    ImageStatusApp? statusApp,
  }) {
    return StateImage(
        raw: raw ?? this.raw, statusApp: statusApp ?? this.statusApp);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [raw, statusApp];
}

enum ImageStatusApp { intisial, loading, success, error, dowload, done }
