
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:textile_exporter_admin/Controller/CommonApiController.dart';
import 'package:textile_exporter_admin/DashBoard/ProductCard.dart';
import 'package:textile_exporter_admin/Library/PhotoViewPage.dart';
import 'package:textile_exporter_admin/Library/Utils.dart';
import 'package:textile_exporter_admin/Model/ImageModel.dart';
import 'package:textile_exporter_admin/Model/SizeModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Library/AppColors.dart';
import '../Library/AppTextStyle.dart';
import '../Model/ProductModel.dart';

class VendorCard extends StatefulWidget {
  const VendorCard({super.key,required this.pData});
  final ProductModel pData;

  @override
  State<VendorCard> createState() => _VendorCardState();
}

class _VendorCardState extends State<VendorCard> {
  ProductModel pData = ProductModel();
  CommonApiController commonApiController = Get.find<CommonApiController>();
  @override
  void initState() {
    pData = widget.pData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey_09,width: 0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: .start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(
                    child: Text(
                      (pData.vendorname ?? "").toString(),
                      style: AppTextStyle.displayMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(width: 10),
                  if((pData.size_data??[]).isNotEmpty)
                  InkWell(
                    onTap: () {
                      updateQtyBottomSheet();
                    },
                    child: Container(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 10,vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadiusGeometry.circular(5)
                      ),
                      child: Text("Update",style: AppTextStyle.labelSmall.copyWith(color: AppColors.white_00),),
                    ),
                  )
                ],
              ),

              if((pData.size_data??[]).isNotEmpty)
                ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  itemCount: (pData.size_data??[]).length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int pIndex) {
                    return ProductCard(sData: (pData.size_data??[])[pIndex]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  updateQtyPopUpOld(){
    return Get.dialog(
       AlertDialog(
          insetPadding: EdgeInsets.symmetric(vertical: 30),
          contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: Row(
            children: [
              Expanded(child: Text('Pickup Status Update',style: AppTextStyle.headlineLarge,)),
              CloseButton(
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            decoration: BoxDecoration(),
                            columnSpacing: 10,
                            headingRowColor: WidgetStatePropertyAll(AppColors.grey_09),
                            horizontalMargin: 8,
                            border: TableBorder.all(color: AppColors.grey_09),
                            columns: [
                              DataColumn(label: Text("Size",style: AppTextStyle.labelMedium)),
                              DataColumn(label: Text("MOQ",style: AppTextStyle.labelMedium)),
                              DataColumn(label: Text("Pending Qty",style: AppTextStyle.labelMedium)),
                              DataColumn(label: Text("Update",style: AppTextStyle.labelMedium)),
                            ],
                            rows:  (pData.size_data??[]).map((e) {
                              return DataRow(
                                  cells: [
                                    DataCell(Text((e.vname??"").toString(),style: AppTextStyle.bodySmall,)),
                                    DataCell(Text((e.moq??"").toString(),style: AppTextStyle.bodySmall,)),
                                    DataCell(Text((e.qty??"").toString(),style: AppTextStyle.bodySmall,)),
                                    DataCell(
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: TextFormField(
                                          initialValue: (e.qty??"").toString(),
                                          style: AppTextStyle.inputText,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                          textInputAction: TextInputAction.next,
                                          onSaved: (value) {
                                            e.update_qty = value.toString();
                                            setState(() {});
                                          },
                                          decoration: Utils().inputFormDecorationSmall('Qty'),
                                        ),
                                      ),
                                    )

                                  ]
                              );
                            },).toList()
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Utils().primaryButton(
                        context: context,
                        btnText: "Save",
                        onPress: () {
                          final form = formKey.currentState!;
                          form.save();
                          Get.back();
                          commonApiController.updateQty(pData);
                        },
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  void updateQtyBottomSheet() {
    Utils().showBottomSheet(
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Pickup Status Update',style: AppTextStyle.headlineLarge,)),
                      CloseButton(
                        onPressed: () {
                          Get.back();
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 15),

                  ListView.builder(
                    padding: EdgeInsets.only(top: 5),
                    itemCount: (pData.size_data??[]).length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int pIndex) {
                      SizeModel sData = (pData.size_data??[])[pIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10)
                          ),
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: .start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    ImageModel iData = ImageModel(showpath: (sData.pimage??"").toString());
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoViewPage(imageList: [iData])));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      height: 70,
                                      width: 60,
                                      child: CachedNetworkImage(
                                        imageUrl: (sData.pimage??"").toString(),
                                        fit: BoxFit.fill,
                                        memCacheHeight: 400,
                                        memCacheWidth: 400,
                                        placeholder: (context, url) => Center(
                                          child: Image.asset(
                                            "assets/images/no_img.png",
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Center(
                                          child: Image.asset(
                                            "assets/images/no_img.png",
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                (sData.ptitle ?? "").toString(),
                                                style: AppTextStyle.bodySmall,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          crossAxisAlignment: .start,
                                          children: [
                                            SizedBox(width: 80,child: Text("Size",style: AppTextStyle.labelVerySmall.copyWith(color: AppColors.grey_10))),
                                            Expanded(child: Text(": ${sData.vname??""}",style: AppTextStyle.displayVerySmall))
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: .start,
                                          children: [
                                            SizedBox(width: 80,child: Text("MOQ",style: AppTextStyle.labelVerySmall.copyWith(color: AppColors.grey_10))),
                                            Expanded(child: Text(": ${sData.moq??""}",style: AppTextStyle.displayVerySmall))
                                          ],
                                        ),
                                        SizedBox(height: 5),

                                        Row(
                                          children: [
                                            SizedBox(width: 80,child: Text("Update Qty",style: AppTextStyle.labelVerySmall,)),
                                            Expanded(
                                              child: TextFormField(
                                                initialValue: (sData.qty ?? "").toString(),
                                                style: AppTextStyle.inputText,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                                validator: (value) {
                                                  if((value??"").toString().trim().isEmpty){
                                                    return "Please enter qty";
                                                  }
                                                  return null;
                                                },
                                                textInputAction: TextInputAction.next,
                                                onSaved: (value) {
                                                  sData.update_qty = value.toString();
                                                  setState(() {});
                                                },
                                                decoration: Utils().inputFormDecorationSmall('Qty'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Utils().primaryButton(
                    context: context,
                    btnText: "Save",
                    onPress: () {
                      final form = formKey.currentState!;
                      form.save();
                      Get.back();
                      commonApiController.updateQty(pData);
                    },
                  ),
                  SizedBox(height: 40,)
                ],
              ),
            ),
          ),
        ),
    );
  }
}