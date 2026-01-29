import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:textile_exporter_admin/Controller/DesktopController.dart';
import 'package:textile_exporter_admin/Library/AppConstant.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'package:textile_exporter_admin/Library/AppColors.dart';
import 'package:textile_exporter_admin/Library/AppDrawer.dart';
import 'package:textile_exporter_admin/Model/TransModel.dart';

import '../Library/Utils.dart';

class DesktopDashboard extends StatefulWidget {
  const DesktopDashboard({super.key});

  @override
  State<DesktopDashboard> createState() => _DesktopDashboardState();
}

class _DesktopDashboardState extends State<DesktopDashboard> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  DesktopController desktopController = Get.put(DesktopController());

  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }
  @override
  void initState() {
    desktopController.selectedCategory.value = "2";
    desktopController.refreshList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
        top: false,
        child: Scaffold(
          key: scaffoldKey,
          drawerEnableOpenDragGesture: true,
          drawer: AppDrawer(),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
              icon: Image.asset("assets/images/menu.png", height: 25),
            ),
            centerTitle: true,
            toolbarHeight: 70,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.white_70
            ),
            backgroundColor: AppColors.white_70,
            title: Text(AppConstant.desktopAppName.toString(),style: AppTextStyle.appBarTitleStyle),
            actions: [
              IconButton(
                  onPressed: () {
                    desktopController.refreshList();
                  },
                  icon: Icon(Icons.refresh_rounded,color: AppColors.primaryColor,size: 30,)
              ),
              const SizedBox(width: 10,)
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                child: Obx(() => SizedBox(
                  height: 45,
                  child: Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: desktopController.categoryList.length,
                      itemBuilder: (context, index) {
                        return Obx(() => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              desktopController.selectedCategory.value = desktopController.categoryList[index]['id'].toString();
                              desktopController.refreshList();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 0),
                              decoration: BoxDecoration(
                                color: desktopController.selectedCategory.value == desktopController.categoryList[index]['id'].toString()
                                    ? AppColors.primaryColor
                                    : AppColors.white_00,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  desktopController.categoryList[index]['name'].toString(),
                                  style: desktopController.selectedCategory.value == desktopController.categoryList[index]['id'].toString()
                                      ? AppTextStyle.labelLarge.copyWith(color: Colors.white)
                                      : AppTextStyle.labelLarge.copyWith(color: AppColors.grey_10),
                                ),
                              ),
                            ),
                          ),
                        ));
                      },
                    ),
                  ),
                )),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible: desktopController.productList.any((e) => e.isSelected == true),
            child: SizedBox(
              height: 55,
              width: Get.width * 0.3,
              child: ElevatedButton(
                onPressed: desktopController.isImporting.value
                    ? null
                    : () {
                  desktopController.importTransAdd();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 2,
                ),
                child: desktopController.isImporting.value
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      desktopController.importingText.value,
                      style: AppTextStyle.displayLarge,
                    ),
                  ],
                )
                    : Text(
                  "Import",
                  style: AppTextStyle.displayLarge.copyWith(
                    fontSize: 16,
                    color: AppColors.white_00,
                    fontWeight: AppTextStyle.bold,
                  ),
                ),
              ),
            ),
          ),
            body: desktopController.isLoading.value
              ? Center(child: SpinKitThreeBounce(color: AppColors.primaryColor, size: 30))
              : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    (desktopController.productList.isEmpty && !(desktopController.isLoading.value))?Center(
                      child: Utils().noItem("No Data Found!"),
                    ):SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                        child: DataTable(
                          showCheckboxColumn: true,
                          onSelectAll: (val) => desktopController.toggleSelectAll(val),
                          columns: [
                            DataColumn(label: Text('Invoice No', style: AppTextStyle.headlineLarge)),
                            DataColumn(label: Text('Date', style: AppTextStyle.headlineLarge)),
                            DataColumn(label: Text('Party Name', style: AppTextStyle.headlineLarge)),
                            DataColumn(label: Text('Type', style: AppTextStyle.headlineLarge)),
                            DataColumn(label: Text('Order', style: AppTextStyle.headlineLarge)),
                            DataColumn(label: Text('Note', style: AppTextStyle.headlineLarge)),
                            DataColumn(label: Text('Total', style: AppTextStyle.headlineLarge)),
                          ],
                          rows: desktopController.productList.asMap().entries.map((entry) {
                            int index = entry.key;
                            TransModel item = entry.value;
                            return DataRow(
                              selected: item.isSelected,
                              onSelectChanged: (val) => desktopController.toggleItemSelection(index, val),
                              cells: [
                                DataCell(Text(item.invoiceno ?? "", style: AppTextStyle.labelMedium)),
                                DataCell(Text(item.tdate.toString().trim().isEmpty?"":DateFormat("dd-MM-yyyy").format(DateTime.parse(item.tdate ?? "")), style: AppTextStyle.labelMedium)),
                                DataCell(Text(item.ac_name ?? "", style: AppTextStyle.labelMedium)),
                                DataCell(Text(item.type ?? "", style: AppTextStyle.labelMedium)),
                                DataCell(Text(item.order ?? "", style: AppTextStyle.labelMedium)),
                                DataCell(Text(item.order_note ?? "", style: AppTextStyle.labelMedium)),
                                DataCell(Text(item.total ?? "", style: AppTextStyle.headlineMedium)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),

                    desktopController.isLoading.value? Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: AppColors.primaryColor,
                          size: 30.0,
                        ),
                      ),
                    ):const SizedBox(),

                    const SizedBox(height: 100,),
                  ],
                ),
              ),
        ),
      );
    });
  }
}
