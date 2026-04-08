import 'dart:convert';


List<SizeModel> SizeModelFromJson(String str) =>
    List<SizeModel>.from(json.decode(str).map((x) => SizeModel.fromJson(x)));

List<SizeModel> SizeModelList(List<dynamic> data ) =>
   List<SizeModel>.from(data.map((x) => SizeModel.fromJson(x)));

String SizeModelListToJson(List<SizeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Map<String,dynamic> SizeModelToJson(SizeModel data) => data.toJson();



class SizeModel{

  String? id;
  String? vname;
  String? moq;
  String? qty;
  String? update_qty;
  String? td_id;
  String? vid;
  String? ptitle;
  String? pimage;
  String? time;
  String? order;
  bool? checked;

  SizeModel({
    this.id,
    this.vname,
    this.moq,
    this.qty,
    this.update_qty,
    this.td_id,
    this.vid,
    this.ptitle,
    this.pimage,
    this.time,
    this.order,
    this.checked,
  });


  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: json['id'],
      vname: json['vname'],
      moq: json['moq'],
      qty: json['qty'],
      update_qty: json['update_qty'],
      td_id: json['td_id'],
      vid: json['vid'],
      ptitle: json['ptitle'],
      pimage: json['pimage'],
      time: json['time'],
      order: json['order'],
      checked: json['checked']??false,
    );
  }


  Map<String,dynamic> toJson() => {
    'id':id,
    'vname':vname,
    'moq':moq,
    'qty':qty,
    'update_qty':update_qty,
    'td_id':td_id,
    'vid':vid,
    'ptitle':ptitle,
    'pimage':pimage,
    'order':order,
    'time':time,
    'checked':checked,
  };

}