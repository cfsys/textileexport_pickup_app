
import 'dart:convert';

List<UserModel> UserModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

List<UserModel> UserModelList(List<dynamic> data ) =>
    List<UserModel>.from(data.map((x) => UserModel.fromJson(x)));

String UserModelListToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Map<dynamic,dynamic> UserModelToJson(UserModel data) => data.toJson();


class UserModel{
  String? uid;
  String? username;
  String? upassword;
  String? uemail;
  String? umobile;
  String? refer_code;
  String? uaddress;
  String? ucity;
  String? ustate;
  String? upincode;
  String? cname;
  String? business_category;
  String? category_name;
  String? qr_code;
  String? ac_number;



  UserModel({
    this.uid,
    this.username,
    this.upassword,
    this.uemail,
    this.umobile,
    this.refer_code,
    this.uaddress,
    this.ucity,
    this.ustate,
    this.upincode,
    this.cname,
    this.business_category,
    this.category_name,
    this.qr_code,
    this.ac_number,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: (json['uid']??"").toString(),
      username: (json['username']??"").toString(),
      upassword: (json['upassword']??"").toString(),
      uemail: (json['uemail']??"").toString(),
      umobile: (json['umobile']??"").toString(),
      refer_code: (json['refer_code']??"").toString(),
      uaddress: (json['uaddress']??"").toString(),
      ucity: (json['ucity']??"").toString(),
      ustate: (json['ustate']??"").toString(),
      upincode: (json['upincode']??"").toString(),
      cname: (json['cname']??"").toString(),
      business_category: (json['business_category']??"").toString(),
      category_name: (json['category_name']??"").toString(),
      qr_code: (json['qr_code']??"").toString(),
      ac_number: (json['ac_number']??"").toString(),
    );}

  Map<String,dynamic> toJson() => {
    'uid':(uid??"").toString(),
    'username':(username??"").toString(),
    'upassword':(upassword??"").toString(),
    'uemail':(uemail??"").toString(),
    'umobile':(umobile??"").toString(),
    'refer_code':(refer_code??"").toString(),
    'uaddress':(uaddress??"").toString(),
    'ucity':(ucity??"").toString(),
    'ustate':(ustate??"").toString(),
    'upincode':(upincode??"").toString(),
    'cname':(cname??"").toString(),
    'business_category':(business_category??"").toString(),
    'category_name':(category_name??"").toString(),
    'qr_code':(qr_code??"").toString(),
    'ac_number':(ac_number??"").toString(),
  };
}