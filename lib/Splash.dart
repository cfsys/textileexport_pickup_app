
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_exporter_admin/Library/AppColors.dart';
import 'package:textile_exporter_admin/Library/AppConstant.dart';
import 'Library/MyNavigator.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isInternetOn = true;
  final splashDelay = 1;

  @override
  void initState() {
    getConnect();
    super.initState();
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      setState(() {
        isInternetOn = false;
      });
    } else {
      loadWidget();
    }
  }

  loadWidget() async {
    var sDuration = Duration(seconds: splashDelay);
    return Timer(sDuration, navigationPage);
  }

  void navigationPage() {
    MyNavigator().goToDashBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Image.asset('assets/images/logo.png',height: Get.width*0.5,),
        ),
      ),
    );
  }
}
