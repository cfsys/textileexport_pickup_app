
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:textile_exporter_admin/Library/Utils.dart';
import 'package:textile_exporter_admin/Model/CategoryModel.dart';
import 'package:textile_exporter_admin/Model/ProductModel.dart';
import '../Library/ApiData.dart';

class CommonApiController extends GetxController implements GetxService{
  RxString selectedCategory = ''.obs;

  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  Future getCategoryList() async {
    try {
      var data = {};
      var res = await ApiData().postData('category_list', data);
      if (res['st'] == "success") {
        categoryList.value = CategoryModelList(res['category']);
      }
    } catch (e) {
      debugPrint('print error: $e');
    }
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
      data['catogory_id'] = selectedCategory.value;
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
      data['id'] = pData.size_data??[];
      var res = await ApiData().postData('update_qty', data);
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