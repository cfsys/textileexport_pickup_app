import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:textile_exporter_admin/Controller/CommonApiController.dart';
import 'package:textile_exporter_admin/DashBoard/Report/Widget/ReportProductCard.dart';
import '../../../Library/AppColors.dart';
import '../../../Library/AppTextStyle.dart';
import '../../../Model/ProductModel.dart';

class ReportVendorCard extends StatelessWidget {
  const ReportVendorCard({super.key,required this.pData, required this.index});
  final ProductModel pData;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey_09,width: 0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
        child: Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: ExpansionTile(
              title: Text(
                (pData.vendorname ?? "").toString(),
                style: AppTextStyle.displayMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            childrenPadding: EdgeInsets.only(right: 10,left: 10,bottom: 10),
            dense: true,
            initiallyExpanded: index == 0,
            iconColor: AppColors.primaryColor,
            children: (pData.size_data??[]).map((e) {
              return ReportProductCard(sData: e);
            },).toList()
          ),
        ),
      ),
    );
  }
}