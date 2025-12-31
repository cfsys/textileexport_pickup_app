import 'dart:convert';


List<FilterModel> FilterModelFromJson(String str) =>
    List<FilterModel>.from(json.decode(str).map((x) => FilterModel.fromJson(x)));

List<FilterModel> FilterModelList(List<dynamic> data ) =>
   List<FilterModel>.from(data.map((x) => FilterModel.fromJson(x)));

String FilterModelListToJson(List<FilterModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Map<String,dynamic> FilterModelToJson(FilterModel data) => data.toJson();



class FilterModel{

  String? psku;
  String? pdesc;
  String? pstock;
  String? pcatagories;

  FilterModel({
    this.psku,
    this.pdesc,
    this.pstock,
    this.pcatagories,
  });


  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
      psku: json['psku'],
      pdesc: json['pdesc'],
      pstock: json['pstock'],
      pcatagories: json['pcatagories'],
    );
  }


  Map<String,dynamic> toJson() => {
    'psku':psku,
    'pdesc':pdesc,
    'pstock':pstock,
    'pcatagories':pcatagories,
  };

}