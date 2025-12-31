
import 'dart:convert';

// ignore: non_constant_identifier_names
List<ImageModel> ImageModelListFromJson(String str) =>
    List<ImageModel>.from(json.decode(str).map((x) => ImageModel.fromJson(x)));

// ignore: non_constant_identifier_names
List<ImageModel> ImageModelList(List<dynamic> data) =>
    List<ImageModel>.from(data.map((x) => ImageModel.fromJson(x)));

// ignore: non_constant_identifier_names
String ImageModelListToJson(List<ImageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageModel {
  String? imageid;
  String? h_path;
  String? c_path;
  String? imagename;
  String? showpath;

  ImageModel({
    this.imageid,
    this.h_path,
    this.c_path,
    this.imagename,
    this.showpath,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageid: (json['imageid'] ?? "").toString(),
      h_path: (json['h_path'] ?? "").toString(),
      c_path: (json['c_path'] ?? "").toString(),
      imagename: (json['imagename'] ?? "").toString(),
      showpath: (json['h_path'] ?? "").toString() + (json['c_path'] ?? "").toString() + (json['imagename'] ?? "").toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'imageid': imageid,
        'h_path': h_path,
        'c_path': c_path,
        'imagename': imagename,
      };
}
