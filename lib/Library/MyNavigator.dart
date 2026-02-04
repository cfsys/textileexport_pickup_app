import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_exporter_admin/Library/AppStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Controller/CommonApiController.dart';
import 'ApiData.dart';
import 'AppColors.dart';
import 'AppConstant.dart';
import 'AppTextStyle.dart';
import 'UpdateAppPage.dart';

class MyNavigator {
  goToDashBoard() async {
      var aaid = await AppStorage.getData("uid") ?? "";
      if ((aaid ?? "").toString().trim().isEmpty) {
        Get.offAllNamed('/LogIn');
      } else {
        getAllAPi();
        if(Platform.isWindows){
          Get.offAllNamed('/DesktopDashboard');
        }else{
          Get.offAllNamed('/Dashboard');
        }
      }
  }

  CommonApiController commonApiController = Get.put(CommonApiController());

  getAllAPi()async{
    commonApiController.getPickupPersonList();
    commonApiController.getCategoryList();
    return;
  }


  versionUpdatePop(BuildContext context, updateLink) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width - 200,
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(60.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              content: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "New version is available. Please update ${AppConstant.appName.toString()} from ${Platform.isAndroid ? "Play Store" : "App Store"}",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodyMedium,
                    ),
                    Column(
                      children: [
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
                                AppColors.primaryColor,
                              ),
                            ),
                            onPressed: () {
                              var url = updateLink.toString();
                              launchUrl(Uri.parse(url.toString()), mode: LaunchMode.externalApplication);
                            },
                            child: Text("Update", style: AppTextStyle.displayLarge.copyWith(color: AppColors.white_00)),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static void goToSignOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    MyNavigator().goToDashBoard();
  }
}
