
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_exporter_admin/DashBoard/Report/ReportPage.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'AppColors.dart';
import 'MyNavigator.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
      ),
      width: MediaQuery.of(context).size.width * 0.6,
      child: ListView(
        children: [
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset("assets/images/logo.png",height: 70)),
              ],
            ),
          ),

          const Divider(indent: 10, thickness: 0.5,color: AppColors.grey_10, endIndent: 10,),


          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportPage()));
            },
            leading: Image.asset("assets/images/report.png", height: 25, width: 25,color: Get.theme.primaryColor,),
            title:  Text(
              'Report',
              style: AppTextStyle.labelMedium,
            ),
          ),
          ListTile(
            onTap: () {
              MyNavigator.goToSignOut();
            },
            leading: Image.asset("assets/images/logout.png", height: 25, width: 25,color: Get.theme.primaryColor,),
            title:  Text(
              'Logout',
              style: AppTextStyle.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
