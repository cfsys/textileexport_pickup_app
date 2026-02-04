
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:textile_exporter_admin/Controller/CommonApiController.dart';
import 'package:textile_exporter_admin/Library/PhotoViewPage.dart';
import 'package:textile_exporter_admin/Library/Utils.dart';
import 'package:textile_exporter_admin/Model/ImageModel.dart';
import 'package:textile_exporter_admin/Model/SizeModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Library/AppColors.dart';
import '../Library/AppTextStyle.dart';
import '../Model/ProductModel.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key,required this.sData});
  final SizeModel sData;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  SizeModel pData = SizeModel();
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
                  ImageModel iData = ImageModel(showpath: (pData.pimage??"").toString());
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PhotoViewPage(imageList: [iData])));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 70,
                    width: 60,
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
                          SizedBox(width: 50,child: Text("Size",style: AppTextStyle.labelVerySmall.copyWith(color: AppColors.grey_10))),
                          Expanded(child: Text(": ${widget.sData.vname??""}",style: AppTextStyle.displayVerySmall))
                        ],
                      ),
                      Row(
                        crossAxisAlignment: .start,
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: .start,
                              children: [
                                SizedBox(width: 50,child: Text("MOQ",style: AppTextStyle.labelVerySmall.copyWith(color: AppColors.grey_10))),
                                Expanded(child: Text(": ${widget.sData.moq??""}",style: AppTextStyle.displayVerySmall))
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: .start,
                              children: [
                                SizedBox(width: 50,child: Text("Qty",style: AppTextStyle.labelVerySmall.copyWith(color: AppColors.grey_10))),
                                Expanded(child: Text(": ${widget.sData.qty??""}",style: AppTextStyle.displayVerySmall))
                              ],
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
  }
}