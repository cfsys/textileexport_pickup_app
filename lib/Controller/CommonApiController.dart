
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:textile_exporter_admin/Library/AppStorage.dart';
import 'package:textile_exporter_admin/Library/Utils.dart';
import 'package:textile_exporter_admin/Model/ProductModel.dart';
import 'package:textile_exporter_admin/Model/SizeModel.dart';
import '../Library/ApiData.dart';

class CommonApiController extends GetxController implements GetxService{
  RxString selectedUser = ''.obs;

  RxList<dynamic> userList = [].obs;
  Future getPickupPersonList() async {
    try {
      var data = {};
      var res = await ApiData().postData('pickup_person_list', data);
      if (res['st'] == "success") {
        userList.value = (res['data']??[]);
      }
    } catch (e) {
      debugPrint('print error: $e');
    }
    return userList;
  }

  RxString selectedCategory = ''.obs;

  RxList<dynamic> categoryList = [].obs;
  Future getCategoryList() async {
    try {
      var data = {};
      var res = await ApiData().postData('vendor_area_list', data);
      if (res['st'] == "success") {
        categoryList.value = (res['data']??[]);
      }
    } catch (e) {
      debugPrint('print error: $e');
    }
    categoryList.insert(0,"All");
    return categoryList;
  }

  RxBool isLoading = false.obs;

  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxList<ProductModel> productList = <ProductModel>[].obs;
  ScrollController scrollController = ScrollController();

  RxInt pageSize = 20.obs;
  RxInt currentPage = 0.obs;

  RxBool isLastPage = false.obs;
  void refreshList() async {
    await Future.delayed(Duration.zero,() async {
      isLastPage.value = false;
      productList.value = [];
      currentPage.value = 0;
      await getProductList();
    });
  }

  void loadMore() async {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if((!isLastPage.value) && (!isLoading.value)){
        await getProductList();
      }
    }
  }

  Future getProductList() async {
    isLoading.value = true;
    List<ProductModel> pList = [];
    try {
      var data = {};
      //data['offset'] = currentPage.value;
      data['search'] = searchController.value.text;
      data['area'] = selectedCategory.value.toString().trim() == "All"?"":selectedCategory.value;
      data['pickup_person_id'] = selectedUser.value.toString().trim() == ""?"":selectedUser.value;
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
    return pList;
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
      data['uid'] = await AppStorage.getData("uid");
      data['td_id'] = tdList;
      var res = await ApiData().postData('update_pickup', data);
      if (res['st'] == 'success') {
        Get.back();
        refreshList();
        Utils().showSnackGetX(msg: res['msg']??"Data Deleted Successfully", snackType: SnackType.success,);
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