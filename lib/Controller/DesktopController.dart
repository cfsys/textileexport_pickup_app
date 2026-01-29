import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:textile_exporter_admin/Library/AppStorage.dart';
import 'package:textile_exporter_admin/Library/Utils.dart';
import 'package:textile_exporter_admin/Model/ProductModel.dart';
import 'package:textile_exporter_admin/Model/SizeModel.dart';
import 'package:textile_exporter_admin/Model/TransModel.dart';
import '../Library/ApiData.dart';

class DesktopController extends GetxController implements GetxService {
  RxString selectedCategory = ''.obs;

  RxList<dynamic> categoryList = [
    {"id": "2", "name": "Sale"},
    {"id": "1", "name": "Purchase"},
  ].obs;

  RxBool isLoading = false.obs;

  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxList<TransModel> productList = <TransModel>[].obs;
  ScrollController scrollController = ScrollController();

  RxInt pageSize = 20.obs;
  RxInt currentPage = 0.obs;

  RxBool isLastPage = false.obs;

  RxBool isAllSelected = false.obs;

  void refreshList() async {
    await Future.delayed(Duration.zero, () async {
      isLastPage.value = false;
      productList.value = [];
      currentPage.value = 0;
      isAllSelected.value = false;
      await getProductList();
    });
  }

  void loadMore() async {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if ((!isLastPage.value) && (!isLoading.value)) {
        await getProductList();
      }
    }
  }

  Future getProductList() async {
    isLoading.value = true;
    try {
      var data = {};
      data['ttype'] = selectedCategory.value.toString().trim() == "" ? "2" : selectedCategory.value;
      var res = await ApiData().postData('trans_list', data);
      if (res['st'] == 'success') {
        productList.value = TransModelList(res['data']);
        isAllSelected.value = false;
      } else {
        Utils().showSnackGetX(msg: res['msg'], snackType: SnackType.error);
      }
    } catch (e) {
      print('print error: $e');
      Utils().showSnackGetX(snackType: SnackType.error, msg: "Catch Error!");
    }
    isLoading.value = false;
    return productList;
  }

  void toggleSelectAll(bool? value) {
    isAllSelected.value = value ?? false;
    for (var item in productList) {
      item.isSelected = isAllSelected.value;
    }
    productList.refresh();
  }

  void toggleItemSelection(int index, bool? value) {
    productList[index].isSelected = value ?? false;
    isAllSelected.value = productList.every((item) => item.isSelected);
    productList.refresh();
  }

  RxString importingText = "".obs;
  RxBool isImporting = false.obs;

  void importTransAdd() async {
    importingText.value = "";
    isImporting.value = true;
    List<TransModel> selectedIds = [];
    for (var product in productList) {
      if (product.isSelected) {
        selectedIds.add(product);
      }
    }
    for (var index = 0; index < selectedIds.length; index++) {
      String id = selectedIds[index].tid.toString();
      try {
        var data = {"tid": id};
        var res = await ApiData().postData('trans_add', data);
        if (res['st'] == 'success') {
          dynamic rData = res['xml'] ?? "";
          importingText.value = "Importing ${selectedIds[index].invoiceno.toString()}...";
          var res2 = await ApiData().importCallData(rData);

          if (res2['st'] == 'success') {
            var data = {"tid": id};
            var res3 = await ApiData().postData('trans_update', data);
            if (res3['st'] == 'success') {
              Utils().showSnackGetX(msg: res3['msg']??"Update Successfully", snackType: SnackType.success);
            }else{
              Utils().showSnackGetX(msg: res3['msg']??"Something Went Wrong", snackType: SnackType.error);
            }
          }else{
            Utils().showSnackGetX(msg: res2['msg']??"Something Went Wrong", snackType: SnackType.error);
          }

        } else {
          Utils().showSnackGetX(msg: res['msg'], snackType: SnackType.error);
        }
      } catch (e) {
        print('catch error in ($id) : $e');
        Utils().showSnackGetX(msg: "Api Catch Error $e", snackType: SnackType.error);
      }
    }
    refreshList();
    isImporting.value = false;
  }
}
