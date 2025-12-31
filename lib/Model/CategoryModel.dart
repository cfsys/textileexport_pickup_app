
import 'dart:convert';
import 'ProductModel.dart';

List<CategoryModel> CategoryModelListFromJson(String str) =>
    List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

List<CategoryModel> CategoryModelList(List<dynamic> data ) =>
    List<CategoryModel>.from(data.map((x) => CategoryModel.fromJson(x)));

String CategoryModelListToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Map<String,dynamic> CategoryModeltoJson(CategoryModel data) => data.toJson();

class CategoryModel{
  String? id;
  String? category_name;
  String? slug;
  String? meta_title;
  String? cat_banner;
  String? cat_img;
  String? h_path;
  String? pc_id;
  String? status;
  String? sort_no;
  String? count;
  bool? has_sub;
  List<CategoryModel>? sub;
  List<ProductModel>? product;


  CategoryModel({
    this.id,
    this.category_name,
    this.slug,
    this.meta_title,
    this.cat_banner,
    this.cat_img,
    this.h_path,
    this.pc_id,
    this.status,
    this.sort_no,
    this.count,
    this.has_sub,
    this.sub,
    this.product,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id']??"").toString(),
      category_name: (json['category_name']??"").toString(),
      slug: (json['slug']??"").toString(),
      meta_title: (json['meta_title']??"").toString(),
      cat_banner: (json['cat_banner']??"").toString(),
      cat_img: (json['cat_img']??"").toString(),
      h_path: (json['h_path']??"").toString(),
      pc_id: (json['pc_id']??"").toString(),
      status: (json['status']??"").toString(),
      sort_no: (json['sort_no']??"").toString(),
      count: (json['count']??"").toString(),
      has_sub: (json['has_sub']??false),
      sub: json['sub'] != null ?CategoryModelList(json['sub']):[],
      product: json['product'] != null ?ProductModelList(json['product']):[],
    );
  }

  Map<String,dynamic> toJson() => {
    'id' : id,
    'category_name' : category_name,
    'slug' : slug,
    'meta_title' : meta_title,
    'cat_banner' : cat_banner,
    'cat_img' : cat_img,
    'h_path' : h_path,
    'pc_id' : pc_id,
    'status' : status,
    'sort_no' : sort_no,
    'count' : count,
    'has_sub' : has_sub,
    'sub' : sub,
    'product' : product,
  };
}