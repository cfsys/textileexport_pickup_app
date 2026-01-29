
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:textile_exporter_admin/Library/Utils.dart';
import 'package:textile_exporter_admin/Library/cfs.dart';
import 'AppConstant.dart';
import 'ManageStore.dart';

// FirebaseMessaging messaging = FirebaseMessaging.instance;
// final FirebaseAuth auth = FirebaseAuth.instance;

class CallApi {
  static const String _url = AppConstant.appUrl;
  static const String importUrl = "http://localhost:9000";

  void printWrapped(text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    print(fullUrl);
    printWrapped(jsonEncode(data));
    //var head = _setHeaders();
    //head['Token'] = await AppStorage.getData("token")??"";
    return await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: _setHeaders());
  }

  Future<http.Response> sendXmlData(String data) async {
    var fullUrl = importUrl;

    print(fullUrl);
    printWrapped(data);

    return await http.post(
      Uri.parse(fullUrl),
      headers: _setHeaders2(),
      body: utf8.encode(data),
    );
  }

  uploadData(data, apiUrl, filename) async {
    var fullUrl = _url + apiUrl;
    var request = http.MultipartRequest('POST', Uri.parse(fullUrl));

    request.fields['aaid'] = data['aaid'];
    request.fields['module'] = data['module'];
    request.files.add(await http.MultipartFile.fromPath('file', filename));

    var res = await http.Response.fromStream(await request.send());
    ApiData().pdata(res.body);

    return res;
  }

  // uploadDataChunk(data,apiUrl,filename)async{
  //   dynamic res;
  //   try{
  //     var fullUrl = _url + apiUrl;
  //
  //     var dataBody = Map<String, dynamic>.from(data);
  //
  //     final dio = Dio(
  //       BaseOptions(
  //         baseUrl: fullUrl,
  //         method: "POST",
  //         headers: {'Authorization': 'Bearer'},
  //       ),
  //     );
  //     final uploader = ChunkedUploader(dio);
  //     res = await uploader.uploadUsingFilePath(
  //       fileName: filename.toString().split("/").last,
  //       filePath: filename,
  //       data: dataBody,
  //       maxChunkSize: 50000000,
  //       path: '/file',
  //       onUploadProgress: (progress) => print(progress),
  //     );
  //   }catch(e){
  //     print("Chunk upload error : $e");
  //   }
  //   return res;
  // }

  uploadMultiData(data, apiUrl, filename) async {

    var fullUrl = _url + apiUrl;
    //print(fullUrl);
    //print(jsonEncode(data));
    var request = http.MultipartRequest('POST', Uri.parse(fullUrl));

    request.fields['aaid'] = data['aaid'] ?? "123";
    request.fields['module'] = data['module'];
    for (int i = 0; i < filename.length; i++) {
      //List<int> imageData = (await File(filename[i]).readAsBytesSync()).buffer.asUint8List();
      List<int> imgdata = [];
      imgdata.addAll(filename[i]);

      request.files.add(await http.MultipartFile.fromBytes(
        'files[]',
        imgdata,
        filename: "${DateTime.now().millisecondsSinceEpoch}.jpg",
      ));
    }

    var res = await http.Response.fromStream(await request.send());
    //   print(res.body);

    return res;
  }

  getData(apiUrl, data) async {
    var fullUrl = _url + apiUrl;
    print(fullUrl);
    var head = _setHeaders();
    head['Token'] = await AppStorage.getData("token")??"";// await _getToken();
    print("jjjjjjjjjjjjjjjj");
    return await http.get(Uri.parse(fullUrl), headers: head);
  }

  _setHeaders() => {
        // 'Authorization' : '4ccda7514adc0f13595a585205fb9761',
        'Content-type': 'application/json',
        //'Accept' : 'application/json',
      };

  Map<String, String> _setHeaders2() => {
    'Content-Type': 'application/xml; charset=utf-8',
    'Accept': 'application/xml',
  };
}

class ApiData {
  pdata(dynamic data) {
    if (kDebugMode) {
      print(data);
    }
  }

  Future set_access_code() async {
    // String? token = await FirebaseMessaging.instance.getToken();

    try {
      var data = {};
      // data["gtoken"] = token.toString();
      data["aaid"] = await AppStorage.getData("aaid")??"";
      var res = await ApiData().postData('set_access_code', data);
      if (res['st'] == "success") {
      }else{
      }
    } catch (e) {
      print('print error: $e');
    }
    return;
  }


  dynamic send_data(dynamic user, String method) async {
    var data = {};
    data = user;

    data["aaid"] = await AppStorage.getData('aaid') ?? '';
    var return_data = {};
    final response = await CallApi().postData(data, method);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result['st'] == 'success') {
        return_data = result;
      } else {
        return_data["st"] = result['st'];
        return_data["msg"] = result['msg'];
      }
    } else {
      return_data["st"] = "error";
      return_data["msg"] = "Please Try Again";
    }
    return return_data;
  }

  dynamic postData(String method, dynamic data) async {
    var return_data = {};
    try {
      data["aaid"] = await AppStorage.getData('aaid') ?? "1234";
      final response = await CallApi().postData(data, method);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['st'] == 'success') {
          return_data = result;
        } else {
          return_data["st"] = result['st'];
          return_data["msg"] = result['msg'];
        }
      } else {
        return_data["st"] = "error";
        return_data["msg"] = "Internal Server Error ${response.statusCode}";
      }
    } catch (e) {
      print("Api Catch Error $e");
      return_data["st"] = "error";
      return_data["msg"] = "Api Catch Error";
    }
    return return_data;
  }

  Future<Map<String, dynamic>> importCallData(String data) async {
    Map<String, dynamic> returnData = {};

    try {
      final response = await CallApi().sendXmlData(data);

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {

          returnData['st'] = 'success';
          returnData['msg'] = 'Imported Successfully';

      } else {
        returnData['st'] = 'error';
        returnData['msg'] = 'Server Error ${response.statusCode}';
      }

    } catch (e) {
      print("API Error: $e");

      returnData['st'] = 'error';
      returnData['msg'] = 'API Exception: $e';
    }

    return returnData;
  }

  dynamic getPostData(String method, dynamic data) async {
    var return_data = {};
    try {
      data["aaid"] = await AppStorage.getData('aaid') ?? "";
      final response = await CallApi().getData(method, data);
      print("ressssssssssssss:${response.body}");
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result);
        if (result['status'] == 'success') {
          return_data = result;
          return_data["st"] = result['st'];
          return_data["msg"] = result['msg'];
        } else {
          return_data["st"] = result['st'];
          return_data["msg"] = result['msg'];
        }
      } else {
        return_data["st"] = "error";
        return_data["msg"] = "Internal Server Error ${response.statusCode}";
      }
    } catch (e) {
      print("Api Catch Error : $e");
      return_data["st"] = "error";
      return_data["msg"] = "Api Catch Error";
    }
    return return_data;
  }


  // dynamic uploadData(dynamic user, String method, String? filename) async {
  //   var return_data = {};
  //
  //   try {
  //     var data = {};
  //     data = user;
  //     data["aaid"] = await AppStorage.getData('aaid') ?? "";
  //     final response = await CallApi().uploadDataChunk(data, method, filename);
  //     if (response.statusCode == 200) {
  //       var result = jsonDecode(response.toString());
  //       if (result['st'] == 'success') {
  //         return_data = result;
  //       } else {
  //         return_data["st"] = result['st'];
  //         return_data["msg"] = result['msg'];
  //       }
  //     } else {
  //       return_data["st"] = "error";
  //       return_data["msg"] = "Something Went Wrong ! Please try again later";
  //     }
  //   } catch (e) {
  //     print("Image Api Error : $e");
  //   }
  //   return return_data;
  // }

  dynamic upload_data(dynamic user, String method, String? filename) async {
    var data = {};
    data = user;

    data["aaid"] = await AppStorage.getData('aaid') ?? '1234';
    var return_data = {};
    final response = await CallApi().uploadData(data, method, filename);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result['st'] == 'success') {
        return_data = result;
      } else {
        return_data["st"] = result['st'];
        return_data["msg"] = result['msg'];
      }
    } else {
      return_data["st"] = "error";
      return_data["msg"] = "Something Went Wrong ! Please try again later";
    }
    return return_data;
  }

  dynamic upload_multi_data(dynamic user, String method, List<dynamic> filename) async {
    var data = {};
    // print(method);
    data = user;

    data["aaid"] = await AppStorage.getData('aaid');
    var return_data = {};
    final response = await CallApi().uploadMultiData(data, method, filename);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      if (result['st'] == 'success') {
        return_data = result;
      } else {
        return_data["st"] = result['st'];
        return_data["msg"] = result['msg'];
      }
    } else {
      return_data["st"] = "error";
      return_data["msg"] = "Please Try Again";
    }
    return return_data;
  }
}
