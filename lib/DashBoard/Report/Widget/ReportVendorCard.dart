import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:textile_exporter_admin/Controller/CommonApiController.dart';
import 'package:textile_exporter_admin/DashBoard/Report/Widget/ReportProductCard.dart';
import '../../../Library/AppColors.dart';
import '../../../Library/AppTextStyle.dart';
import '../../../Model/ProductModel.dart';

class ReportVendorCard extends StatefulWidget {
  const ReportVendorCard({super.key,required this.pData});
  final ProductModel pData;

  @override
  State<ReportVendorCard> createState() => _ReportVendorCardState();
}

class _ReportVendorCardState extends State<ReportVendorCard> {
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
                ],
              ),

              if((pData.size_data??[]).isNotEmpty)
                ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  itemCount: (pData.size_data??[]).length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int pIndex) {
                    return ReportProductCard(sData: (pData.size_data??[])[pIndex]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}