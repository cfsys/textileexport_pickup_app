
import 'dart:io';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:textile_exporter_admin/Library/AppColors.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'package:path_provider/path_provider.dart';

class CropImage extends StatefulWidget {
  const CropImage({super.key,required this.image,required this.onCrop});
  final String image;
  final ValueChanged<String> onCrop;

  @override
  State<CropImage> createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {

  late CustomImageCropController controller;

  @override
  void initState() {
    controller = CustomImageCropController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Crop Image",style: AppTextStyle.headlineLarge,),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomImageCrop(
              canRotate: false,
              shape: CustomCropShape.Square,
              clipShapeOnCrop: true,
              imageFit:CustomImageFit.fitVisibleSpace,
              forceInsideCropArea: true,
              cropController: controller,
              image: FileImage(File(widget.image)),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.white_00,
        onPressed: () async {
          Navigator.pop(context);
          final image = await controller.onCropImage();
          Directory ePath = await getTemporaryDirectory();
          var savePath =  '${ePath.path}/${DateTime.now().microsecondsSinceEpoch.toString()}.jpg';
          final file = File(savePath);
          await file.writeAsBytes(image!.bytes);
          widget.onCrop(file.path);
          },
        label: Text("Crop", style: AppTextStyle.displaySmall),
        icon: Icon(Icons.crop),
      ),
    );
  }
}
