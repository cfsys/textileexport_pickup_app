import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:textile_exporter_admin/Controller/ReportController.dart';
import 'package:textile_exporter_admin/DashBoard/Report/Widget/ReportVendorCard.dart';
import 'package:textile_exporter_admin/DashBoard/VendorCard.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'package:textile_exporter_admin/Library/AppColors.dart';
import 'package:textile_exporter_admin/Library/Utils.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  ReportController reportController = Get.put(ReportController());

  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }
  @override
  void initState() {
    reportController.setCurrentDate();
    reportController.getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded,color: AppColors.white_00,size: 25,),
              ),
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.primaryColor,
                statusBarIconBrightness: Brightness.light,
              ),
              backgroundColor: AppColors.primaryColor,
              title: Text("Report",style: AppTextStyle.appBarTitleStyle.copyWith(color: AppColors.white_00)),
              bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: AppTextStyle.inputText,
                            controller: reportController.searchController.value,
                            textCapitalization: TextCapitalization.sentences,
                            cursorColor: AppColors.black,
                            textInputAction: TextInputAction.search,
                            onFieldSubmitted: (val) {
                              reportController.searchController.value.text = val.toString();
                              if (debounce?.isActive ?? false) debounce?.cancel();
                              debounce = Timer(const Duration(milliseconds: 500), () async {
                                reportController.getProductList();
                              });
                            },
                            onChanged: (val) async {
                              reportController.searchController.value.text = val.toString();
                              if (debounce?.isActive ?? false) debounce?.cancel();
                              debounce = Timer(const Duration(milliseconds: 500), () async {
                                reportController.getProductList();
                              });
                            },
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Search...",
                              isDense: true,
                              hintStyle: AppTextStyle.textHint,
                              filled: true,
                              fillColor: AppColors.white_00,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              prefixIcon: Icon(Icons.search,color: AppColors.primaryColor,size: 22,),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    reportController.searchController.value.text = "";
                                    reportController.getProductList();
                                  },
                                  style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                                  icon: Icon(Icons.close_rounded,color: AppColors.primaryColor,size: 20,)
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.white_00,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.white_00, width: 1.5),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.white_00,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              actions: [
                SizedBox(
                  width: Get.width * 0.4,
                  child: TextFormField(
                    controller: reportController.dateController.value,
                    style: AppTextStyle.inputText,
                    cursorColor: AppColors.black,
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                    expands: false,
                    readOnly: true,
                    onTap: () async {
                      var date = await Utils().selectDate(
                        context: context,
                        currDate: reportController.dateFormat.value,
                      );
                      if ((date ?? "") != "" || reportController.dateController.value.text.isEmpty) {
                        reportController.dateFormat.value = date;
                        reportController.dateController.value.text = DateFormat("dd-MM-yyyy").format(DateTime.parse(date.toString())).toString();
                        reportController.searchController.value.text = "";
                        reportController.getProductList();
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "",
                      prefixIcon: Icon(Icons.calendar_month_rounded,color: AppColors.primaryColor,size: 22,),
                      isDense: true,
                      hintStyle: AppTextStyle.textHint,
                      filled: true,
                      fillColor: AppColors.white_00,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.white_00,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.white_00, width: 1.5),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppColors.white_00,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
              ],
              // bottom: commonApiController.categoryList.isNotEmpty?PreferredSize(
              //   preferredSize: const Size.fromHeight(40),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              //     child: Obx(() => SizedBox(
              //         height: 35,
              //         child: ListView.builder(
              //           shrinkWrap: true,
              //           scrollDirection: Axis.horizontal,
              //           itemCount: commonApiController.categoryList.length,
              //           itemBuilder: (context, index) {
              //             return Obx(() => Padding(
              //               padding: const EdgeInsets.only(right: 10),
              //               child: GestureDetector(
              //                 onTap: () {
              //                   if(commonApiController.selectedCategory.value == commonApiController.categoryList[index].toString()){
              //                     commonApiController.selectedCategory.value = "";
              //                   }else{
              //                     commonApiController.selectedCategory.value = commonApiController.categoryList[index].toString();
              //                   }
              //                   commonApiController.refreshList();
              //                 },
              //                 child: Container(
              //                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              //                   decoration: BoxDecoration(
              //                       color: commonApiController.selectedCategory.value == commonApiController.categoryList[index].toString()
              //                           ? AppColors.primaryColor
              //                           : AppColors.white_00,
              //                       borderRadius: BorderRadius.circular(30),
              //                   ),
              //                   child: Center(
              //                     child: Text(
              //                       commonApiController.categoryList[index].toString(),
              //                       style: commonApiController.selectedCategory.value == commonApiController.categoryList[index].toString()
              //                           ? AppTextStyle.labelMedium.copyWith(color: Colors.white)
              //                           : AppTextStyle.labelMedium.copyWith(color: AppColors.grey_10),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ));
              //           },
              //         ),
              //       )),
              //   ),
              // ):null,
            ),
            body: reportController.isLoading.value
                ? Center(
              child: SpinKitThreeBounce(
                color: AppColors.primaryColor,
                size: 30,
              ),
            )
                : RefreshIndicator(
              onRefresh: () async {
                reportController.getProductList();
                setState(() {});
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [

                  if (reportController.productList.isEmpty &&
                      !reportController.isLoading.value)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Utils().noItem("No Data Found!"),
                      ),
                    )

                  else
                    SliverPadding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return ReportVendorCard(
                              pData: reportController.productList[index],
                            );
                          },
                          childCount: reportController.productList.length,
                        ),
                      ),
                    ),

                  if (reportController.isLoading.value)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Center(
                          child: SpinKitThreeBounce(
                            color: AppColors.primaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
            )
          ),
        ),
      );
    });
  }
}
