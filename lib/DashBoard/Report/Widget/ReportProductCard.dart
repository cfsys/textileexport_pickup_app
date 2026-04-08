

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_exporter_admin/Controller/ReportController.dart';
import 'package:textile_exporter_admin/Library/PhotoViewPage.dart';
import 'package:textile_exporter_admin/Model/ImageModel.dart';
import 'package:textile_exporter_admin/Model/SizeModel.dart';

import '../../../Library/AppColors.dart';
import '../../../Library/AppTextStyle.dart';
class ReportProductCard extends StatefulWidget {
  const ReportProductCard({super.key,required this.sData});
  final SizeModel sData;

  @override
  State<ReportProductCard> createState() => _ReportProductCardState();
}

class _ReportProductCardState extends State<ReportProductCard> {
  SizeModel pData = SizeModel();
  ReportController reportController = Get.find();
  @override
  void initState() {
    pData = widget.sData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        elevation: 2,
        color: AppColors.white_00,
        shape: RoundedRectangleBorder(
           borderRadius: BorderRadiusGeometry.circular(10)
        ),
        margin: EdgeInsets.zero,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  InkWell(
                    onTap: () {
                      ImageModel iData = ImageModel(showpath: (pData.pimage??"").toString());
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoViewPage(imageList: [iData])));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 105,
                        width: 80,
                        child: CachedNetworkImage(
                          imageUrl: (pData.pimage??"").toString(),
                          fit: BoxFit.fill,
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
                                  (pData.ptitle ?? "").toString(),
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
                              Text("Size : ",style: AppTextStyle.labelVerySmall.copyWith(color: AppColors.grey_10)),
                              Expanded(child: Text(pData.vname??"",style: AppTextStyle.displayVerySmall))
                            ],
                          ),
                          Row(
                            crossAxisAlignment: .start,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text("MOQ : ",style: AppTextStyle.labelVerySmall.copyWith(color: AppColors.grey_10)),
                                    Expanded(child: Text(pData.moq??"",style: AppTextStyle.displayVerySmall))
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text("Qty : ",style: AppTextStyle.labelVerySmall.copyWith(color: AppColors.grey_10)),
                                    Expanded(child: Text(pData.qty??"",style: AppTextStyle.displayVerySmall))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Text("Order : ",style: AppTextStyle.labelVerySmall.copyWith(color: AppColors.grey_10)),
                                        Expanded(child: Text(pData.order??"",style: AppTextStyle.displayVerySmall))
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Text("Time : ",style: AppTextStyle.labelVerySmall.copyWith(color: AppColors.grey_10)),
                                        Expanded(child: Text(pData.time??"",style: AppTextStyle.displayVerySmall))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
                right: 0,
                child: Checkbox(
                  value: pData.checked??false,
                  activeColor: AppColors.primaryColor,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (value) async{
                    pData.checked = value??false;
                    bool isSuccess = await reportController.updateCheck(pData);
                    if(isSuccess){
                      pData.checked = value??false;
                    }else{
                      pData.checked = !(value??false);
                    }
                    setState(() {});
                  },
                )
            )
          ],
        ),
      ),
    );
  }
}