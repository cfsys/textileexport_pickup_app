
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../Library/ApiData.dart';
import '../Library/Utils.dart';
import '../Model/CategoryModel.dart';
import '../Model/FilterModel.dart';
import '../Model/ProductModel.dart';


class ProductController extends GetxController implements GetxService{

  Rx<GlobalKey<FormState>> productFormKey = GlobalKey<FormState>().obs;
  Rx<FilterModel> fData = FilterModel().obs;
  Rx<TextEditingController> barcodeController = TextEditingController().obs;
  Rx<ProductModel> pData = ProductModel().obs;
  RxBool saveLoading = false.obs;
  RxBool isLoading = false.obs;
  late Future fProduct;


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

  RxList<String> selectedItemList = <String>[].obs;
  addItem(String cId){
    if(selectedItemList.contains(cId.toString().trim())){
      selectedItemList.remove(cId.toString());
    }else{
      selectedItemList.add(cId.toString());
    }
  }


  Rx<TextEditingController> searchController = TextEditingController().obs;

  var selectedCategoriesId = "".obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  getCategoryListPList() async{
    try {
      categoryList.value = [];
      var data = {};
      var res = await ApiData().postData('categorydata', data);
      if (res['st'] == 'success') {
        categoryList.value = CategoryModelList(res['data']);
      }else{
        Utils().showSnackGetX(
            msg: res['msg'],
            snackType: SnackType.error
        );
      }
    } catch (e) {
      print('print error getCategoryList: $e');
    }
    return categoryList;
  }

  RxList<dynamic> sortList = [].obs;
  RxList<String> selectedSort = <String>[].obs;

  Future getProductList() async {
    isLoading.value = true;
    List<ProductModel> pList = [];
    try {
      var data = {};
      data['filter'] = fData;
      data['offset'] = currentPage.value;
      data['search'] = searchController.value.text;
      var res = await ApiData().postData('catalog_list', data);
      if (res['st'] == 'success') {
        pList = ProductModelList(res['product']);
        if(pList.length < pageSize.value){
          isLastPage.value = true;
        }
        productList.addAll(pList);
        currentPage += pList.length;
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

  Future deleteProduct(pId) async {
    Utils().loadingGetX(
        text: "Loading"
    );
    try {
      var data = {};
      data['pid'] = pId;
      var res = await ApiData().postData('product_delete', data);
      print(res);
      if (res['st'] == "success") {
        Get.back();
        Utils().showSnackGetX(
          msg: res['msg']??"Product deleted successfully",
          snackType: SnackType.success,
        );
        refreshList();
      }else{
        Get.back();
        Utils().showSnackGetX(
          msg: res['msg']??"Something went wrong!",
          snackType: SnackType.error,
        );
      }
    } catch (e) {
      Get.back();
      Utils().showSnackGetX(
        msg: "Internal catch error!",
        snackType: SnackType.error,
      );
      print('print error: $e');
    }
  }

  Future getProductData(pId) async {
    try {
      var data = {};
      data['pid'] = pId;
      var res = await ApiData().postData('product_get', data);
      if (res['st'] == "success") {
        pData.value = ProductModel.fromJson(res['product']);

      }
    } catch (e) {
      print('print error: $e');
    }
    return pData;
  }

  Future updateProductStatus(type) async {
    Utils().loadingGetX();
    try {
      var data = {};
      data['pid'] = selectedItemList.join(',');
      data['status'] = type.toString();
      var res = await ApiData().postData('update_catalog_status', data);
      if (res['st'] == "success") {
        Get.back();
        refreshList();
        selectedItemList.clear();
        Utils().showSnackGetX(msg: res['msg']??"Data updated successfully", snackType: SnackType.success);
      }else{
        Get.back();
        Utils().showSnackGetX(msg: res['msg']??"Something went wrong", snackType: SnackType.error);
      }
    } catch (e) {
      Get.back();
      print('print error: $e');
    }
    return;
  }

  Future updateStockStatus(type) async {
    Utils().loadingGetX();
    try {
      var data = {};
      data['pid'] = selectedItemList.join(',');
      data['status'] = type.toString();
      var res = await ApiData().postData('update_catalog_stock_status', data);
      if (res['st'] == "success") {
        Get.back();
        refreshList();
        selectedItemList.clear();
        Utils().showSnackGetX(msg: res['msg']??"Data updated successfully", snackType: SnackType.success);
      }else{
        Get.back();
        Utils().showSnackGetX(msg: res['msg']??"Something went wrong", snackType: SnackType.error);
      }
    } catch (e) {
      Get.back();
      print('print error: $e');
    }
    return;
  }


}