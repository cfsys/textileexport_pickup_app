import 'dart:convert';
import 'dart:ui';

import 'ImageModel.dart';
import 'ProductModel.dart';

List<DetailModel> DetailModelFromJson(String str) =>
    List<DetailModel>.from(json.decode(str).map((x) => DetailModel.fromJson(x)));

List<DetailModel> DetailModelList(List<dynamic> data ) =>
    List<DetailModel>.from(data.map((x) => DetailModel.fromJson(x)));

String DetailModelListToJson(List<DetailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Map<String,dynamic> DetailModelToJson(DetailModel data) => data.toJson();



class DetailModel{
  String? td_id;
  String? ptitle;
  String? category_name;
  String? pref_td;
  String? pid;
  String? pqty;
  String? pending_qty;
  String? total_qty;
  String? qtn_bal;
  String? prate;
  String? ptax;
  String? tax_id;
  String? taxamt;
  String? tax_name;
  String? subamount;
  String? pvatav;
  String? pmrp;
  bool? fix_rate;
  String? psku;
  String? pdn;
  String? remark;
  String? pnote;
  String? p_color;
  String? p_color_name;
  String? cid;
  ImageModel? pimages;
  ImageModel? pready_image;
  ProductModel? product;

  String? tid;
  String? vid;
  String? vname;
  String? ttype;
  String? batchId;
  String? key;
  String? pqty_bal;

  String? pvatavamt;
  String? amount;
  String? gtotal;
  String? ostatus;

  DetailModel({
    this.td_id,
    this.ptitle,
    this.category_name,
    this.pref_td,
    this.pid,
    this.pqty,
    this.total_qty,
    this.pending_qty,
    this.qtn_bal,
    this.prate,
    this.ptax,
    this.tax_id,
    this.taxamt,
    this.tax_name,
    this.subamount,
    this.pvatav,
    this.pmrp,
    this.fix_rate,
    this.psku,
    this.pdn,
    this.remark,
    this.pnote,
    this.p_color,
    this.p_color_name,
    this.cid,
    this.pimages,
    this.pready_image,
    this.product,

    this.tid,
    this.vid,
    this.vname,
    this.ttype,
    this.batchId,
    this.key,
    this.pqty_bal,

    this.pvatavamt,
    this.amount,
    this.gtotal,
    this.ostatus,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      td_id: (json['td_id']??"").toString(),
      ptitle: (json['ptitle']??"").toString(),
      category_name: (json['category_name']??"").toString(),
      pref_td: (json['pref_td']??"").toString(),
      pid: (json['pid']??"").toString(),
      pqty: (json['pqty']??"1").toString(),
      total_qty: (json['total_qty']??"").toString(),
      pending_qty: (json['pending_qty']??"").toString(),
      qtn_bal: (json['qtn_bal']??"0").toString(),
      prate: (json['prate']??"").toString(),
      ptax: (json['ptax']??"").toString(),
      tax_id: (json['tax_id']??"").toString(),
      taxamt: (json['taxamt']??"").toString(),
      tax_name: (json['tax_name']??"").toString(),
      subamount: (json['subamount']??"").toString(),
      pvatav: (json['pvatav']??"").toString(),
      pmrp: (json['pmrp']??"").toString(),
      fix_rate: json['fix_rate']??true,
      psku: (json['psku']??"").toString(),
      pdn: (json['pdn']??"").toString(),
      remark: (json['remark']??"").toString(),
      pnote: (json['pnote']??"").toString(),
      p_color: json['p_color']??"FFFFFF",
      p_color_name: (json['p_color_name']??"").toString(),
      cid: (json['cid']??"").toString(),
      pimages: json['pimages'] == null?ImageModel():ImageModel.fromJson(json['pimages']),
      pready_image: json['pready_image'] == null?ImageModel():ImageModel.fromJson(json['pready_image']),
      product: json['product'] == null?ProductModel():ProductModel.fromJson(json['product']),

      tid: json['tid'],
      vid: json['vid'],
      vname: json['vname'],
      ttype: json['ttype'],
      batchId: json['batchId'],
      key: json['key'],
      pqty_bal: json['pqty_bal'],

      pvatavamt: json['pvatavamt'],
      amount: json['amount'],
      gtotal: json['gtotal'],
      ostatus: json['ostatus'],
    );
  }

  Map<String,dynamic> toJson() => {
    'td_id':td_id,
    'ptitle':ptitle,
    'category_name':category_name,
    'pref_td':pref_td,
    'pid':pid,
    'pqty':pqty,
    'total_qty':total_qty,
    'pending_qty':pending_qty,
    'qtn_bal':qtn_bal,
    'prate':prate,
    'ptax':ptax,
    'tax_id':tax_id,
    'taxamt':taxamt,
    'tax_name':tax_name,
    'subamount':subamount,
    'pvatav':pvatav,
    'pmrp':pmrp,
    'fix_rate':fix_rate,
    'psku':psku,
    'pdn':pdn,
    'remark':remark,
    'pnote':pnote,
    'p_color':p_color,
    'p_color_name':p_color_name,
    'cid':cid,
    'pimages':pimages,
    'pready_image':pready_image,
    'product':product,

    'tid':tid,
    'vid':vid,
    'vname':vname,
    'ttype':ttype,
    'batchId':batchId,
    'key':key,
    'pqty_bal':pqty_bal,

    'pvatavamt':pvatavamt,
    'amount':amount,
    'gtotal':gtotal,
    'ostatus':ostatus,
  };

}