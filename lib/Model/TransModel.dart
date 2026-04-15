import 'dart:convert';


List<TransModel> TransModelFromJson(String str) =>
    List<TransModel>.from(json.decode(str).map((x) => TransModel.fromJson(x)));

List<TransModel> TransModelList(List<dynamic> data ) =>
   List<TransModel>.from(data.map((x) => TransModel.fromJson(x)));

String TransModelListToJson(List<TransModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Map<String,dynamic> TransModelToJson(TransModel data) => data.toJson();



class TransModel{

  String? tid;
  String? invoiceno;
  String? tdate;
  String? type;
  String? order;
  String? order_note;
  String? admin_note;
  String? total;
  String? ship_address_text;
  String? tallyShipAddressText;
  String? tallyVoucherNumber;
  String? ac_name;
  String? guid;
  bool? notInTally;
  bool isSelected;

  TransModel({
    this.tid,
    this.invoiceno,
    this.tdate,
    this.type,
    this.order,
    this.order_note,
    this.admin_note,
    this.total,
    this.ship_address_text,
    this.tallyShipAddressText,
    this.tallyVoucherNumber,
    this.ac_name,
    this.guid,
    this.notInTally,
    this.isSelected = false,
  });


  factory TransModel.fromJson(Map<String, dynamic> json) {
    return TransModel(
      tid: json['tid'],
      invoiceno: json['invoiceno'],
      tdate: json['tdate'],
      type: json['type'],
      order: json['order'],
      order_note: json['order_note'],
      admin_note: json['admin_note'],
      total: json['total'],
      ship_address_text: json['ship_address_text'],
      ac_name: json['ac_name'],
      guid: json['guid'],
      notInTally: json['isInTally']??false,
      isSelected: false,
    );
  }


  Map<String,dynamic> toJson() => {
    'tid':tid,
    'invoiceno':invoiceno,
    'tdate':tdate,
    'type':type,
    'order':order,
    'order_note':order_note,
    'admin_note':admin_note,
    'total':total,
    'ship_address_text':ship_address_text,
    'tallyShipAddressText':tallyShipAddressText,
    'tallyVoucherNumber':tallyVoucherNumber,
    'guid':guid,
    'isInTally':notInTally,
    'ac_name':ac_name,
  };

}
