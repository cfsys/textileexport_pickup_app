
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
    dateFormat.value = DateFormat("yyyy-MM-dd").format(DateTime.now());
  }
  Rx<TextEditingController> dateController = TextEditingController(text: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString()).obs;
  RxString dateFormat = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;

  RxList<ProductModel> productList = <ProductModel>[].obs;

  Future getProductList() async {
    isLoading.value = true;
    productList.value = [];
    try {
      var data = {};
      if(searchController.value.text.trim().isNotEmpty){
        data['search'] = searchController.value.text;
      }else {
        data['pickup_date'] = dateFormat.value;
      }
      var res = await ApiData().postData('get_pickup_report_data', data);
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



  updateCheck(SizeModel sData)async{
    bool isSuccess = false;
    Utils().loadingGetX();
    try{
      var data = {};
      data['id'] = sData.id.toString();
      data['is_checked'] = (sData.checked??false)?"1":"0";
      var res = await ApiData().postData('report_check_update', data);
      if (res['st'] == 'success') {
        isSuccess = true;
        Get.back();
        Utils().showSnackGetX(msg: res['msg']??"Data Updated Successfully", snackType: SnackType.success,);
      } else{
        Get.back();
        Utils().showSnackGetX(msg: res['msg']??"Something went wrong!", snackType: SnackType.error,);
      }
    }catch(e){
      Get.back();
      print('ERRO :- $e');
    }
    return isSuccess;
  }
}