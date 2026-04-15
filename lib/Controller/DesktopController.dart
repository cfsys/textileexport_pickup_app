import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    {"id": "3", "name": "Sale-Imported"}
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
      data['ttype'] = ((selectedCategory.value.toString().trim() == "") || (selectedCategory.value.toString().trim() == "3")) ? "2" : selectedCategory.value;
      data['extra_filter'] = selectedCategory.value.toString().trim() == "3" ? "sale_imported" : "";
      var res = await ApiData().postData('trans_list', data);
      if (res['st'] == 'success') {
        transList.value = TransModelList(res['data']);
        if(await _checkTallyConnection()){
          for (var i = 0; i < transList.length; ++i) {
            bool exists = await checkLedgerExists(transList[i].ac_name.toString());
            transList[i].notInTally = !exists;
          }
        }else{
          for (var i = 0; i < transList.length; ++i) {
            transList[i].notInTally = false;
          }
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

  RxBool isFetchingTallyVouchers = false.obs;
  RxString fetchingTallyText = "".obs;

  DateTime? _parseAnyDate(String? value) {
    final v = (value ?? "").trim();
    if (v.isEmpty) return null;
    try {
      return DateTime.parse(v);
    } catch (_) {}
    try {
      return DateFormat("dd-MM-yyyy").parseStrict(v);
    } catch (_) {}
    try {
      return DateFormat("dd/MM/yyyy").parseStrict(v);
    } catch (_) {}
    return null;
  }

  String _buildVoucherRegisterXml({required String fDate,required String tDate}) {
    return """
<ENVELOPE>
  <HEADER>
    <VERSION>1</VERSION>
    <TALLYREQUEST>Export</TALLYREQUEST>
    <TYPE>Data</TYPE>
    <ID>Voucher Register</ID>
  </HEADER>
  <BODY>
    <DESC>
      <STATICVARIABLES>
        <SVFROMDATE>$fDate</SVFROMDATE>
        <SVTODATE>$tDate</SVTODATE>
        <SVEXPORTFORMAT>\$\$SysName:XML</SVEXPORTFORMAT>
      </STATICVARIABLES>
    </DESC>
  </BODY>
</ENVELOPE>
""";
  }

  Map<String, String> _extractVoucherXmlByRemoteId(String envelopeXml) {
    final map = <String, String>{};
    final voucherReg = RegExp(r"<VOUCHER\b([\s\S]*?)</VOUCHER>", caseSensitive: false);
    final remoteIdReg = RegExp(r'REMOTEID="([^"]+)"', caseSensitive: false);

    for (final m in voucherReg.allMatches(envelopeXml)) {
      final voucherXml = "<VOUCHER${m.group(1) ?? ""}</VOUCHER>";
      final idMatch = remoteIdReg.firstMatch(voucherXml);
      final remoteId = (idMatch?.group(1) ?? "").trim();
      if (remoteId.isNotEmpty) {
        map[remoteId] = voucherXml;
      }
    }
    return map;
  }

  String? _extractVoucherNumber(String voucherXml) {
    final m = RegExp(r"<VOUCHERNUMBER>([\s\S]*?)</VOUCHERNUMBER>", caseSensitive: false)
        .firstMatch(voucherXml);
    final v = (m?.group(1) ?? "").trim();
    return v.isEmpty ? null : v;
  }

  Future<void> fetchTallyVouchersForFirstDateAndMapToTrans() async {
    if (isFetchingTallyVouchers.value) return;
    if (transList.isEmpty) {
      Utils().showSnackGetX(msg: "No Data Found!", snackType: SnackType.error);
      return;
    }

    final dt = _parseAnyDate(transList.first.tdate.toString());
    if (dt == null) {
      Utils().showSnackGetX(msg: "Invalid Date in first row!", snackType: SnackType.error);
      return;
    }

    if (!await _checkTallyConnection()) {
      Utils().showSnackGetX(msg: "Tally not connected!", snackType: SnackType.error);
      return;
    }

    isFetchingTallyVouchers.value = true;
    fetchingTallyText.value = "Updating...";

    try {
      final fDate = DateFormat("yyyyMMdd").format(dt);
      final tDate = DateFormat("yyyyMMdd").format(DateTime.now());
      final xml = _buildVoucherRegisterXml(fDate: fDate,tDate: tDate);
      final response = await CallApi().sendXmlData(xml);

      if (response.statusCode != 200) {
        Utils().showSnackGetX(
          msg: "Tally error ${response.statusCode}",
          snackType: SnackType.error,
        );
        return;
      }

      final voucherByRemoteId = _extractVoucherXmlByRemoteId(response.body);
      for (final item in transList) {
        final guid = (item.guid ?? "").trim();
        if (guid.isEmpty) continue;
        final vXml = voucherByRemoteId[guid];
        if (vXml == null) continue;

        item.tallyVoucherNumber = _extractVoucherNumber(vXml);
        if((item.tallyVoucherNumber??"").toString().trim().isNotEmpty) {
          await transUpdateInv(item.tid.toString(), item.tallyVoucherNumber ?? "");
        }
      }
      refreshList();
    } catch (e) {
      Utils().showSnackGetX(msg: "Tally fetch error: $e", snackType: SnackType.error);
    } finally {
      isFetchingTallyVouchers.value = false;
      fetchingTallyText.value = "";
    }
  }

  Future<void> transUpdateInv(String tId,String invNo) async {
    try {
      var data = {"tid": tId.toString(),"inv_tally":invNo.toString()};
      var res = await ApiData().postData('trans_update_tally_inv', data);
      if (res['st'] == 'success') {
        dynamic rData = res['xml'] ?? "";
        var res2 = await ApiData().importCallData(rData);

      } else {
        Utils().showSnackGetX(msg: res['msg'], snackType: SnackType.error);
      }
    } catch (e) {
      print('catch error in ($tId) : $e');
      Utils().showSnackGetX(msg: "Api Catch Error $e", snackType: SnackType.error);
    }
    return;
  }

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
