
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:textile_exporter_admin/Library/AppStorage.dart';
import 'package:textile_exporter_admin/Library/Utils.dart';
import 'package:textile_exporter_admin/Model/ProductModel.dart';
import 'package:textile_exporter_admin/Model/SizeModel.dart';
import '../Library/ApiData.dart';

class ReportController extends GetxController implements GetxService{
  RxBool isLoading = false.obs;

  Rx<TextEditingController> searchController = TextEditingController().obs;
  void setCurrentDate() {
    dateController.value.text =
        DateFormat("dd-MM-yyyy").format(DateTime.now());
    dateFormat.value = DateTime.now().toString();
  }
  Rx<TextEditingController> dateController = TextEditingController(text: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString()).obs;
  RxString dateFormat = DateTime.now().toString().obs;

  RxList<ProductModel> productList = <ProductModel>[].obs;

  Future getProductList() async {
    isLoading.value = true;
    productList.value = [];
    try {
      var data = {};
      if(searchController.value.text.trim().isNotEmpty){
        data['search'] = searchController.value.text;
      }else {
        data['date'] = dateFormat.value;
      }
      var res = await ApiData().postData('get_pickup_list', data);
      if (res['st'] == 'success') {
        productList.value = ProductModelList(res['data']);
      }else{
        Utils().showSnackGetX(
            msg: res['msg'],
            snackType: SnackType.error
        );
      }
    } catch (e) {
      print('print error: $e');
      Utils().showSnackGetX(
        snackType: SnackType.error,
        msg: "Catch Error!",
      );
    }
    isLoading.value = false;
    return ;
  }



  updateQty(ProductModel pData)async{
    Utils().loadingGetX();
    try{
      var data = {};
      List<String> tdList = [];
      for (var i = 0; i < (pData.size_data??[]).length; ++i) {
        SizeModel sData = (pData.size_data??[])[i];
        tdList.add((sData.td_id??"").toString());
        data['size_update_${sData.td_id.toString()}'] = (sData.update_qty??"").toString();
        data['vid_${sData.td_id.toString()}'] = (sData.vid??"").toString();
      }
      data['pid'] = (pData.pid??"").toString();
      data['uid'] = pData.sid.toString();
      data['td_id'] = tdList;
      var res = await ApiData().postData('update_pickup', data);
      if (res['st'] == 'success') {
        Get.back();
        getProductList();
        Utils().showSnackGetX(msg: res['msg']??"Data Updated Successfully", snackType: SnackType.success,);
      } else{
        Get.back();
        Utils().showSnackGetX(msg: res['msg']??"Something went wrong!", snackType: SnackType.error,);
      }
    }catch(e){
      Get.back();
      print('ERRO :- $e');
    }
  }
}