
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textile_exporter_admin/Library/ApiData.dart';
import 'package:textile_exporter_admin/Library/AppStorage.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'package:intl/intl.dart';
import 'package:textile_exporter_admin/Model/ImageModel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'AppColors.dart';

enum ButtonType{large,regular,small}
enum SnackType{common,warning,error,success}
enum PermissionType{storage,location,camera}


class Utils extends GetxController implements GetxService {

  greenTag({required String tag}){
    return Container(
      decoration:  BoxDecoration(
        color: Get.isDarkMode?AppColors.greenTagColorDark:AppColors.green_09,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 4),
        child: Center(child: Text(tag.toString(),style: AppTextStyle.displayVeryVerySmall.copyWith(color: Get.isDarkMode?AppColors.greenTextColorDark:AppColors.greenTextColorLight))),
      ) ,
    );
  }

  yellowTag({required String tag}){
    return Container(
      decoration:  BoxDecoration(
        color: Get.isDarkMode?AppColors.yellowTagColorDark:AppColors.yellow_09,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 4),
        child: Center(child: Text(tag.toString(),style: AppTextStyle.displayVeryVerySmall.copyWith(color: Get.isDarkMode?AppColors.yellowTextColorDark:AppColors.yellowTextColorLight))),
      ) ,
    );
  }

  redTag({required String tag}){
    return Container(
      decoration:  BoxDecoration(
        color: Get.isDarkMode?AppColors.redTagColorDark:AppColors.red_00.withAlpha(50),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 4),
        child: Center(child: Text(tag.toString(),style: AppTextStyle.displayVeryVerySmall.copyWith(color: Get.isDarkMode?AppColors.redTextColorDark:AppColors.red_00))),
      ) ,
    );
  }

  regularTag({required String tag}){
    return Container(
      decoration:  BoxDecoration(
        color: Get.isDarkMode?AppColors.blueTagColorDark:AppColors.blue_09,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 4),
        child: Center(child: Text(tag.toString(),style: AppTextStyle.displayVeryVerySmall.copyWith(color: Get.isDarkMode?AppColors.blueTextColorDark:AppColors.blue_00))),
      ) ,
    );
  }

  fullWidth(context){
    return MediaQuery.of(context).size.width;
  }


  Future getPermissionGetX({required PermissionType permissionType}) async {
    //late PermissionStatus pStatus;
    var pStatus;
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo;
    int androidVersion = 0;
    if (Platform.isAndroid) {
      androidInfo = await info.androidInfo;
      androidVersion = int.parse(androidInfo.version.release);
    }
    bool havePermission = false;

    String pText = "";
    if (permissionType == PermissionType.storage) {
      if (androidVersion >= 13) {
        pStatus = await [Permission.photos, Permission.videos].request();
      } else {
        pStatus = await [Permission.storage].request();
      }
      pText = "Please grant permission to store data in your device.";
    } else if (permissionType == PermissionType.location) {
      pStatus = await [Permission.location].request();
      pText = "Please grant permission to access your location.";
    } else if (permissionType == PermissionType.camera) {
      pStatus = await [Permission.camera].request();
      pText = "Please grant permission to access your phone camera.";
    } else {
      pText = "Please grant permission.";
    }
    havePermission = pStatus.values.every((status) => status == PermissionStatus.granted);
    //
    // if (!havePermission) {
    //   Utils().messagePopGetX(
    //     msg: pText,
    //     btnText: "Grant",
    //     onTapBtn: () async {
    //       await openAppSettings();
    //     },
    //     btnColor: AppColors.primaryColor,
    //   );
    // }
    return true;
  }

  saveFile({required BuildContext context, bool isOpenPdf = true, bool isShare = false,required String pdfPath, String? categoryName}) async {
    if (await getPermissionGetX(permissionType: PermissionType.storage) == false) {
      return "";
    }

    loadingGetX();

    var savePath = "";
    try {
      Directory? ePath;
      if (Platform.isAndroid) {
        ePath = Directory('/storage/emulated/0/Download');
      } else {
        ePath = await getApplicationDocumentsDirectory();
      }

      var targetDir = ePath;
      if (categoryName != null && categoryName.isNotEmpty) {
        targetDir = Directory('${ePath.path}/${categoryName.toString().trim()}');
        if (!await targetDir.exists()) {
          await targetDir.create(recursive: true);
        }
      }

      String imgPath = pdfPath;
      var bytes = (await NetworkAssetBundle(Uri.parse(imgPath)).load(imgPath)).buffer.asUint8List();

      var pdfName = "image_${DateTime.now().millisecondsSinceEpoch}.${imgPath.toString().split(".").last}";
      savePath = '${targetDir.path}/$pdfName';

      final file = File(savePath);
      await file.writeAsBytes(bytes);

      Navigator.pop(context);
      Utils().showSnack(
        context: context,
        msg: "Image saved to Downloads/${categoryName ?? ''}",
        snackType: SnackType.success,
      );

      if (isOpenPdf) {
        OpenFile.open(savePath);
      }
    } catch (e) {
      print("File Save Error : $e");
      Navigator.pop(context);
      Utils().showSnack(
        context: context,
        msg: "Download failed",
        snackType: SnackType.error,
      );
    }
    return savePath.toString();
  }

  loadingGetX({String? text}) async {
    return await Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Container(
            color: AppColors.white_00,
            height: 50,
            child: Center(
              child: Row(
                children: [
                  CircularProgressIndicator(color: AppColors.primaryColor),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    text??'Loading',
                    style: AppTextStyle.labelMedium,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  showBottomSheet({isDrag = false, isBottomPadding = false, required content, double? padding,double? bottomSheetHeight,Color? clr}) {
    return Get.bottomSheet(
        SafeArea(
          top: false,
          child: Container(
            height: bottomSheetHeight,
            color: clr??AppColors.primaryBackGroundColor,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: padding ?? 35),
                child: content,
              ),
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        enableDrag: isDrag,
        isScrollControlled: true
    );
  }

  numberFormat(data) {
    NumberFormat formatter = NumberFormat("#,##,##,##,##,###.##");
    var resNum = formatter.format(double.parse((data ?? "").toString().trim() == "" ? "0" : data.toString()));
    return resNum;
  }

  pickImagePopGetX() async {
    final imageSource = await Get.dialog<ImageSource>(
        barrierDismissible: true,
        Dialog(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add Photo",
                  style: AppTextStyle.displayLarge,
                ),
                const SizedBox(height: 15.0,),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back(result: ImageSource.gallery);
                          // Navigator.pop(context, ImageSource.gallery);
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Image.asset(
                              "assets/image/gallery.png",
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back(result: ImageSource.camera);
                          // Navigator.pop(context, ImageSource.camera);
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Image.asset(
                              "assets/image/camera.png",
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
    var iPath = "";
    if (imageSource != null) {
      iPath = await pickImage(imageSource);
    }
    return iPath;
  }

  pickImage(ImageSource pickImage) async {
    var imagePicker = ImagePicker();

    dynamic pickedFile;
    var fileC = "";
    try {
      pickedFile = await imagePicker.pickImage(
        source: pickImage,
        imageQuality: 50,
      );
      var sFile = File(pickedFile.path);
      //File file = await FlutterExifRotation.rotateImage(path: pickedFile!.path);
      //var newFilePath = file.parent.path + '/thumb_' + file.path.split('/').last;
      var newFilePath = '${sFile.parent.path}/thumb_${sFile.path.split('/').last}';
      fileC = sFile.path.toString();

      // var fileType = newFilePath.toString().split(".").last;
      // CompressFormat compressFormat = fileType.toString().toLowerCase() == "png"?CompressFormat.png
      //     :fileType.toString().toLowerCase() == "heic"?CompressFormat.heic
      //     :CompressFormat.jpeg;
      // fileC = await FlutterImageCompress.compressAndGetFile(
      //   sFile.absolute.path,
      //   newFilePath,
      //   format: compressFormat,
      //   quality: 100,
      //   minWidth: 1000,
      //   autoCorrectionAngle: true,
      //   minHeight: 1000,
      // );

      print('1111111111111111111');
      print(sFile.path);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return fileC != "" ? fileC.toString() : "";
  }

  Future uploadImage({required String file, required String module, required String apiName, required dynamic data}) async {
    ImageModel img = ImageModel();
    try {
      var user_data = {};
      user_data = data;
      user_data['module'] = module;
      var res = await ApiData().upload_data(user_data, apiName, file);
      if (res['st'] == "success") {
        img = ImageModel.fromJson(res['image']);
      }
    } catch (e) {
      print("Image Error : $e");
    }
    return img;
  }

  //input decoration
  InputDecoration inputSimpleDecoration(String label,String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorStyle: AppTextStyle.textError,
      hoverColor: AppColors.black,
      hintStyle: AppTextStyle.textHint,
      labelStyle: AppTextStyle.textHint,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.only(top:0.0,bottom: 5,left: 5.0,right: 5.0),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey_09,width: 1.0),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.black,width: 1.0),
      ),
    );
  }

  InputDecoration inputFormDecoration(String msg) {
    return InputDecoration(
      errorStyle: AppTextStyle.textError,
      hintText: msg,
      hintStyle: AppTextStyle.textHint,
      labelText: msg,
      labelStyle: AppTextStyle.inputText,
      counterText: "",
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.white_90,
          width: 1.8,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            // color: Get.theme.primaryColor,
            color: AppColors.white_90,
            width: 1.8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.white_90,
          width: 1.8,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  InputDecoration inputFormDecoration2(String msg) {
    return InputDecoration(
      errorStyle: AppTextStyle.textError,
      hintText: msg,
      hintStyle: AppTextStyle.textHint,
      labelText: "",
      labelStyle: AppTextStyle.inputText,
      counterText: "",
      isDense: true,
      // filled: true,
      // fillColor: Get.isDarkMode?AppColors.primaryBackGroundColorDark:AppColors.white_90,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
      // border: OutlineInputBorder(
      //   borderSide: BorderSide.none,
      //   borderRadius: BorderRadius.circular(5.0),
      // ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.white_90,
          width: 1.8,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          // color: Get.theme.primaryColor,
            color: AppColors.white_90,
            width: 1.8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.white_90,
          width: 1.8,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  InputDecoration inputFormDecorationSmall(String msg) {
    return InputDecoration(
      errorStyle: AppTextStyle.textError.copyWith(fontSize: 12),
      hintText: msg,
      hintStyle: AppTextStyle.textHint,
      counterText: "",
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.inputColor,
          width: 1.8,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: AppColors.black,
            width: 1.8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.inputColor,
          width: 1.8,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  InputDecoration inputFormDecorationSmallWithLabel(String msg) {
    return InputDecoration(
      errorStyle: AppTextStyle.textError,
      hintText: msg,
      hintStyle: AppTextStyle.textHint,
      labelText: msg,
      labelStyle: AppTextStyle.inputText,
      counterText: "",
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.inputColor,
          width: 1.8,
        ),
        borderRadius: BorderRadius.circular(14.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: AppColors.black,
            width: 1.8),
        borderRadius: BorderRadius.circular(14.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.inputColor,
          width: 1.8,
        ),
        borderRadius: BorderRadius.circular(14.0),
      ),
    );
  }

  BoxDecoration dropdownDecoration(){
    return BoxDecoration(
      border: Border.all(
        color: AppColors.inputColor,
        width: 1.8,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  showDialogBox({required content,action}){
    Get.defaultDialog(
      titleStyle: AppTextStyle.titleLarge.copyWith(fontWeight: AppTextStyle.bold,fontSize: 0),
      barrierDismissible: true,
      backgroundColor: AppColors.white_00,
      content: content,
      actions: action,
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
    );
    /*showDialog(context: context,
        builder:(BuildContext context){
          return  AlertDialog(
            backgroundColor: AppColors.white_00,
            scrollable: true,
            content:content,
            actions:action,
          );
        });*/
  }

  primaryButton({required context, IconData? icon,Color? btnColor,Color? textColor,ButtonType buttonType = ButtonType.regular, required String btnText, double? height, double? width, required Function() onPress, bool isLoading = false,EdgeInsetsGeometry? padding }) {
    return InkWell(
      onTap: (){
        if(!isLoading){
          onPress();
        }
      },
      child: Container(
        height: height??(buttonType == ButtonType.small? 30 : 55),
        width: width??(buttonType == ButtonType.small? 30 : fullWidth(context)*0.65),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(buttonType == ButtonType.small?10:100),
            color: btnColor??AppColors.primaryColor,
            // boxShadow: const [
            //   BoxShadow(
            //     color: AppColors.grey_09,
            //     offset: Offset(0,5),
            //     blurRadius: 10.0,
            //   ),
            // ]
        ),
        child: isLoading?const Center(
          child: SpinKitThreeBounce(
            size: 25.0,
            color: AppColors.white_00,
          ),
        ):Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: icon != null,
                child: Padding(
                  padding: const EdgeInsets.only(right:0),
                  child: Icon(icon,color: AppColors.white_00,size: buttonType == ButtonType.small?18:22),
                ),
              ),

              Text(
                btnText,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.displayLarge.copyWith(fontSize:  buttonType == ButtonType.small?14:16,color: textColor??AppColors.white_00,fontWeight: AppTextStyle.bold),
                // style:  fontStyle.buttonTextWhite.copyWith(fontSize: buttonType == ButtonType.small?13:16, color: textColor??AppColors.white_00),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showSnackGetX({required String msg, required SnackType snackType}) {
    Get.showSnackbar(GetSnackBar(
      animationDuration: Duration.zero,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderRadius: 20,
      duration: const Duration(milliseconds: 1000),
      backgroundColor: snackType == SnackType.error ? AppColors.red_55 : snackType == SnackType.warning ? AppColors.yellowTextColorLight : snackType == SnackType.success ? AppColors.green_45 : AppColors.black,
      messageText: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white_00,
              ),
              child: snackType == SnackType.error ? const Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.red_55,
                  size: 22,
                ),
              )
                  : snackType == SnackType.warning
                  ? const Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(
                  Icons.priority_high_rounded,
                  color: AppColors.yellowTextColorLight,
                  size: 22,
                ),
              )
                  : snackType == SnackType.success
                  ? const Padding(
                padding: EdgeInsets.all(3.0),
                child: Icon(
                  Icons.done_rounded,
                  color: AppColors.green_45,
                  size: 22,
                ),
              )
                  : const SizedBox(),
            ),
          ),
          Expanded(
            child: Text(
              msg,
              style: AppTextStyle.labelMedium.copyWith(color: AppColors.white_00),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ));
  }

  showSnack({required context,required String msg,required SnackType snackType}) {
    Get.showSnackbar(
      GetSnackBar(
        messageText: Row(
          children: [
             Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white_00,
                ),
                child: snackType == SnackType.error?const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.red_55,
                    size: 22,
                  ),
                ):snackType == SnackType.warning?const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.priority_high_rounded,
                    color: AppColors.yellowTextColorLight,
                    size: 22,
                  ),
                ):snackType == SnackType.success?const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.done_rounded,
                    color: AppColors.green_45,
                    size: 22,
                  ),
                ):const SizedBox(),
              ),
            ),
             Expanded(
              child: Text(
                msg,
                style: AppTextStyle.labelMedium.copyWith(color: AppColors.white_00),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        borderRadius: 18.0,
        maxWidth: MediaQuery.of(context).size.width * .9,
        duration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        snackPosition:SnackPosition.BOTTOM,
        backgroundColor: snackType == SnackType.error?AppColors.red_55:snackType == SnackType.warning?AppColors.yellowTextColorLight:snackType == SnackType.success?AppColors.green_45:AppColors.black,
      ),
    );
 /*   ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white_00,
                ),
                child: snackType == SnackType.error?const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.red_55,
                    size: 22,
                  ),
                ):snackType == SnackType.warning?const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.priority_high_rounded,
                    color: AppColors.yellowTextColorLight,
                    size: 22,
                  ),
                ):snackType == SnackType.success?const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.done_rounded,
                    color: AppColors.green_45,
                    size: 22,
                  ),
                ):const SizedBox(),
              ),
            ),

            Expanded(
              child: Text(
                msg,
                style: fontStyle.snackText,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 1500),
        elevation: 5,
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        backgroundColor: snackType == SnackType.error?AppColors.red_55:snackType == SnackType.warning?AppColors.yellowTextColorLight:snackType == SnackType.success?AppColors.green_45:AppColors.black,
        width: MediaQuery.of(context).size.width * .9,
      ),
    );*/
  }

  Future selectDate({required BuildContext context, firstDate, lastDate, currDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: AppColors.white_00,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor:Colors.blue[900],
          ),
          child: child!,
        );
      },
      initialDate: DateTime.parse(currDate),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    DateTime tSelectedDate = DateTime.parse(currDate);
    if (picked != null) {
      tSelectedDate = DateTime(picked.year, picked.month, picked.day,);
    }
    return (tSelectedDate ?? "").toString();
  }

  Future<bool> onWillPop(BuildContext context) async {
    return (await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width-200,
            child: AlertDialog(
              backgroundColor: Get.theme.primaryColorLight,
              insetPadding: const EdgeInsets.all(60.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),),
              /*title: Text(
                    'Exit Application?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat-SemiBold',
                    ),
                  ),*/
              content: Padding(
                padding: const EdgeInsets.only(left:20.0,right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Are you sure you want to quit this app?',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.labelMedium,
                    ),

                    Column(
                      children: [
                        const SizedBox(height: 20.0,),
                        SizedBox(
                          width:double.infinity,
                          height: 42,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              )),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.primaryColor,),
                            ),
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            child: Text("Quit", style: AppTextStyle.displayLarge.copyWith(color: AppColors.white_00)),
                          ),
                        ),

                        InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child:  Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                              child: Text("Cancel", style:AppTextStyle.displayLarge.copyWith(color: AppColors.primaryColor)),
                            )
                        ),
                      ],
                    ),

                  ],
                ),
              ),



            ),
          );
        })) ??
        false;
  }

  messagePopGetX({required String msg, required String btnText, required Function onTapBtn, required Color btnColor}) async {
    return Get.dialog(AlertDialog(
      insetPadding: const EdgeInsets.all(60.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    msg.toString(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.labelMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all<Color>(
                    btnColor,
                  ),
                ),
                onPressed: () {
                  Get.back();
                  onTapBtn();
                },
                child: Text(btnText, style: AppTextStyle.displayMedium.copyWith(color: AppColors.white_00)),
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    ));
  }

  confirmPop({required BuildContext context,required Function onPressed,required String title,required String btnText,required Color btnColor}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          backgroundColor: Get.theme.primaryColorLight,
          insetPadding: const EdgeInsets.all(50.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.labelMedium,
                ),
                const SizedBox(
                  height: 15,
                ),

                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        fixedSize: Size(MediaQuery.of(context).size.width, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        onPressed();
                      },
                      child: Text(
                        btnText,
                        style: AppTextStyle.headlineLarge.copyWith(color: AppColors.white_00)
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                            child: Text(
                              "Cancel",
                              style: AppTextStyle.headlineLarge.copyWith(
                                color: btnColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  noItem(text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: Get.height*0.3),
        child: Text(text, style: AppTextStyle.displayLarge,),
      ),
    );
  }
}
