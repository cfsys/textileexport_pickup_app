import 'dart:convert';


List<SizeModel> SizeModelFromJson(String str) =>
    List<SizeModel>.from(json.decode(str).map((x) => SizeModel.fromJson(x)));

List<SizeModel> SizeModelList(List<dynamic> data ) =>
   List<SizeModel>.from(data.map((x) => SizeModel.fromJson(x)));

String SizeModelListToJson(List<SizeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Map<String,dynamic> SizeModelToJson(SizeModel data) => data.toJson();



class SizeModel{

  String? vname;
  String? moq;
  String? qty;
  String? update_qty;
  String? td_id;
  String? vid;
  String? ptitle;
  String? pimage;

  SizeModel({
    this.vname,
    this.moq,
    this.qty,
    this.update_qty,
    this.td_id,
    this.vid,
    this.ptitle,
    this.pimage,
  });


  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      vname: json['vname'],
      moq: json['moq'],
      qty: json['qty'],
      update_qty: json['update_qty'],
      td_id: json['td_id'],
      vid: json['vid'],
      ptitle: json['ptitle'],
      pimage: json['pimage'],
    );
  }


  Map<String,dynamic> toJson() => {
    'vname':vname,
    'moq':moq,
    'qty':qty,
    'update_qty':update_qty,
    'td_id':td_id,
    'vid':vid,
    'ptitle':ptitle,
    'pimage':pimage,
  };

}