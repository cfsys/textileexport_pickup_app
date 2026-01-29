import 'package:flutter/material.dart';
import 'package:textile_exporter_admin/Desktop/DesktopDashboard.dart';
import 'Authentication/Login.dart';
import 'package:get/get.dart';
import 'DashBoard/HomePage.dart';
import 'Library/AppConstant.dart';
import 'Library/CustomTheme.dart';
import 'Splash.dart';

void main() async{
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings ){
        switch(settings.name){
          case "/Dashboard":Navigator.push(context,MaterialPageRoute(builder: (context)=>const HomePage()));
          break;
          default:
            throw Exception("Invalid route:${settings.name}");
        }
        return null;
      },
      routes: {
        "/Dashboard":(context)=> const HomePage(),
        "/DesktopDashboard":(context)=> const DesktopDashboard(),
        "/LogIn":(context)=> const LoginPage(),
      },
      title: AppConstant.appName,
      theme: CustomTheme.lightTheme,
      // darkTheme: CustomTheme.darkTheme,
      //themeMode: ThemeMode.system,
      home:const SplashScreen(),
    );
  }
}

