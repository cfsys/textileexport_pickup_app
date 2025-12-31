
import 'dart:convert';
import 'package:textile_exporter_admin/Model/SizeModel.dart';

import 'ImageModel.dart';


List<ProductModel> ProductModelFromJson(String str) =>
    List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

List<ProductModel> ProductModelList(List<dynamic> data) =>
    List<ProductModel>.from(data.map((x) => ProductModel.fromJson(x)));

String ProductModelListToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Map<dynamic, dynamic> ProductModelToJson(ProductModel data) => data.toJson();

class ProductModel {
  String? pid;
  String? ptitle;
  String? slug;
  String? prod_sku;
  String? pprice;
  String? pmoq;
  String? pqty;
  String? vid;
  String? fabric_text;
  String? pdesc;
  String? pcprice;
  String? pbrand;
  String? pweight;
  String? vendorname;
  String? work;
  String? size_text;
  String? category_text;
  String? tax_val;
  String? download_link;
  String? share_text;
  String? contact_inq;
  String? lable;
  String? thumbnail;
  ImageModel? pimages;
  List<dynamic>? ptag;
  List<dynamic>? pgalary;
  List<SizeModel>? size_data;
  dynamic pvariation_val;
  dynamic addon;
  dynamic brand;
  List? selected_addon;
  String? addon_amt;
  String? is_inquiry;

  ProductModel({
    this.pid,
    this.ptitle,
    this.slug,
    this.prod_sku,
    this.pprice,
    this.pmoq,
    this.pqty,
    this.vid,
    this.fabric_text,
    this.pdesc,
    this.pcprice,
    this.pbrand,
    this.pweight,
    this.vendorname,
    this.work,
    this.size_text,
    this.category_text,
    this.tax_val,
    this.download_link,
    this.share_text,
    this.contact_inq,
    this.lable,
    this.thumbnail,
    this.pimages,
    this.ptag,
    this.pgalary,
    this.size_data,
    this.pvariation_val,
    this.addon,
    this.brand,
    this.selected_addon,
    this.addon_amt,
    this.is_inquiry,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    pid: (json["pid"]??"").toString(),
    ptitle: (json["ptitle"]??"").toString(),
    slug: (json["slug"]??"").toString(),
    prod_sku: (json["prod_sku"]??"").toString(),
    pprice:( json["pprice"]??"").toString(),
    pmoq:( json["pmoq"]??"").toString(),
    pqty:( json["pqty"]??"").toString(),
    vid:( json["vid"]??"").toString(),
    fabric_text:( json["fabric_text"]??"").toString(),
    pdesc:( json["pdesc"]??"").toString(),
    pcprice:( json["pcprice"]??"").toString(),
    pbrand:( json["pbrand"]??"").toString(),
    pweight:( json["pweight"]??"").toString(),
    vendorname:( json["vendorname"]??"").toString(),
    work:( json["work"]??"").toString(),
    size_text:( json["size_text"]??"").toString(),
    category_text:( json["category_text"]??"").toString(),
    tax_val:( json["tax_val"]??"").toString(),
    download_link:( json["download_link"]??"").toString(),
    share_text:( json["share_text"]??"").toString(),
    contact_inq:( json["contact_inq"]??"").toString(),
    lable:( json["lable"]??"").toString(),
    thumbnail: (json["thumbnail"]??"").toString(),
    pimages: (json['pimages']??"") == ""?ImageModel():ImageModel.fromJson(json['pimages']),
    ptag: (json['ptag']??"") == ""?[]:json['ptag'],
    pgalary: (json['pgalary']??"") == ""?[]:json['pgalary'],
    size_data: (json['size_data']??"") == ""?[]:SizeModelList(json['size_data']),
    pvariation_val: json['pvariation_val'],
    addon: json['addon'],
    brand: json['brand'],
    selected_addon: json['selected_addon']??[],
    addon_amt:( json["addon_amt"]??"").toString(),
    is_inquiry:( json["is_inquiry"]??"").toString(),
  );

  Map<String, dynamic> toJson() => {
    "pid": pid,
    "slug": slug,
    "ptitle": ptitle,
    "prod_sku": prod_sku,
    "pprice": pprice,
    "pmoq": pmoq,
    "pqty": pqty,
    "vid": vid,
    "fabric_text": fabric_text,
    "pdesc": pdesc,
    "pcprice": pcprice,
    "pbrand": pbrand,
    "pweight": pweight,
    "vendorname": vendorname,
    "work": work,
    "size_text": size_text,
    "category_text": category_text,
    "tax_val": tax_val,
    "download_link": download_link,
    "share_text": share_text,
    "contact_inq": contact_inq,
    "lable": lable,
    "thumbnail": thumbnail,
    "pimages": pimages,
    "ptag": ptag,
    "pgalary": pgalary,
    "size_data": size_data,
    "pvariation_val": pvariation_val,
    "addon": addon,
    "brand": brand,
    "selected_addon": selected_addon,
    "addon_amt": addon_amt,
    "is_inquiry": is_inquiry,
  };
}
