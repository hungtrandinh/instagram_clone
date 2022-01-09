class ImageApi {
  final Raw urls;
  ImageApi({required this.urls});
  ImageApi.fromJson(Map<String, dynamic> json)
      : urls = Raw.fromJson(json["urls"]);
}

class GetApiAll {
  final List<ImageApi> imageApi;

  GetApiAll({required this.imageApi});
  GetApiAll.fromJson(Map<String, dynamic> json)
      : imageApi =
            (json['results'] as List).map((e) => ImageApi.fromJson(e)).toList();
}

class Raw {
  final String row;

  Raw(this.row);
  Raw.fromJson(Map<String, dynamic> json) : row = json["raw"];
}
