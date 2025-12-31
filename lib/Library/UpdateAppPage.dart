
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AppColors.dart';
import 'MyNavigator.dart';

class UpdateAppPage extends StatefulWidget {
  const UpdateAppPage({super.key, this.title, required this.updateLink, this.isUpdatePage});
  final bool? isUpdatePage;
  final String? title;
  final String updateLink;

  @override
  State<UpdateAppPage> createState() => _UpdateAppPageState();
}

class _UpdateAppPageState extends State<UpdateAppPage> {

  @override
  void initState() {
    super.initState();
  }

  willPopCallback(){
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        willPopCallback();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleSpacing: 0,
          leading:IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.black),
            onPressed:(){
              SystemNavigator.pop();
            }, // null disables the button
          ),
          title: Text("Back", style: AppTextStyle.headlineLarge),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 50.0,),

              Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              widget.isUpdatePage??false?Column(
                children: [
                  const SizedBox(height: 40,),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:50.0),
                    child: Text("An updated version of the app is now available. Please update to continue using all features.",style: AppTextStyle.displayLarge,textAlign: TextAlign.center,),
                  ),

                  const SizedBox(height: 40,),
                  InkWell(
                    onTap: () async{
                      try {
                        var url = widget.updateLink.toString();
                        await launchUrl(Uri.parse(url.toString()), mode: LaunchMode.externalApplication);
                      }catch(e){
                        print('link error $e');
                      }
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.primaryColor
                      ),
                      child: Center(
                        child: Text("Click To Update", style: AppTextStyle.displayMedium.copyWith(color: AppColors.white_00),),
                      ),
                    ),
                  ),
                ],
              ):Column(
                children: [
                  const SizedBox(height: 40,),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:50.0),
                    child: Text("App is currently under maintenance. Please check back soon.",style: AppTextStyle.displayLarge,textAlign: TextAlign.center,),
                  ),
                ],
              ),

              const SizedBox(height: 100,),
            ],
          ),
        ),
      ),
    );
  }
}
