import 'dart:io';

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

  RxList<TransModel> transList = <TransModel>[].obs;
  ScrollController scrollController = ScrollController();

  RxInt pageSize = 20.obs;
  RxInt currentPage = 0.obs;

  RxBool isLastPage = false.obs;

  RxBool isAllSelected = false.obs;

  void refreshList() async {
    await Future.delayed(Duration.zero, () async {
      isLastPage.value = false;
      transList.value = [];
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

  Future<bool> _checkTallyConnection() async {
    bool isTallyConnected = false;
    try {
      final request = await HttpClient()
          .getUrl(Uri.parse(CallApi.importUrl));
      final response = await request.close();

      if (response.statusCode == 200) {
        isTallyConnected = true;
      }
    } catch (e) {
      print(e);
    }

    return isTallyConnected;
  }

  String _escapeXml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  Future<bool> checkLedgerExists(String ledgerName) async {
    if (!await _checkTallyConnection()) {
      return true;
    }
    final safeName = _escapeXml(ledgerName.trim());

    final xml = """
<ENVELOPE>
 <HEADER>
  <VERSION>1</VERSION>
  <TALLYREQUEST>Export</TALLYREQUEST>
  <TYPE>Collection</TYPE>
  <ID>LedgerCheck</ID>
 </HEADER>
 <BODY>
  <DESC>
   <STATICVARIABLES>
    <SVEXPORTFORMAT>\$\$SysName:XML</SVEXPORTFORMAT>
   </STATICVARIABLES>
   <TDL>
    <TDLMESSAGE>
     <COLLECTION NAME="LedgerCheck">
      <TYPE>Ledger</TYPE>
      <FETCH>Name</FETCH>
      <FILTER>LedgerFilter</FILTER>
     </COLLECTION>

     <SYSTEM TYPE="Formulae" NAME="LedgerFilter">
      \$Name = "$safeName"
     </SYSTEM>

    </TDLMESSAGE>
   </TDL>
  </DESC>
 </BODY>
</ENVELOPE>
""";

    try {
      final response = await CallApi().sendXmlData(xml);

      if (response.body.contains(safeName)) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future getProductList() async {
    isLoading.value = true;
    try {
      var data = {};
      data['ttype'] = selectedCategory.value.toString().trim() == "" ? "2" : selectedCategory.value;
      var res = await ApiData().postData('trans_list', data);
      if (res['st'] == 'success') {
        transList.value = TransModelList(res['data']);
        for (var i = 0; i < transList.length; ++i) {
          bool exists = await checkLedgerExists(transList[i].ac_name.toString());
          transList[i].notInTally = !exists;
        }
        isAllSelected.value = false;
      } else {
        Utils().showSnackGetX(msg: res['msg'], snackType: SnackType.error);
      }
    } catch (e) {
      print('print error: $e');
      Utils().showSnackGetX(snackType: SnackType.error, msg: "Catch Error!");
    }
    isLoading.value = false;
    return transList;
  }

  void toggleSelectAll(bool? value) {
    isAllSelected.value = value ?? false;
    for (var item in transList) {
      item.isSelected = isAllSelected.value;
    }
    transList.refresh();
  }

  void toggleItemSelection(int index, bool? value) {
    transList[index].isSelected = value ?? false;
    isAllSelected.value = transList.every((item) => item.isSelected);
    transList.refresh();
  }

  RxString importingText = "".obs;
  RxBool isImporting = false.obs;

  void importTransAdd() async {
    importingText.value = "";
    isImporting.value = true;
    List<TransModel> selectedIds = [];
    for (var product in transList) {
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
            //var res3 = await ApiData().postData('trans_update', data);
            //if (res3['st'] == 'success') {
            //  Utils().showSnackGetX(msg: res3['msg']??"Update Successfully", snackType: SnackType.success);
            //}else{
             // Utils().showSnackGetX(msg: res3['msg']??"Something Went Wrong", snackType: SnackType.error);
            //}
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
