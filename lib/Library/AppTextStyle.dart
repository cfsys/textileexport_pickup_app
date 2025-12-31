
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AppColors.dart';

class AppTextStyle {

  static TextStyle appFonts = GoogleFonts.roboto(color: Get.theme.primaryColor);

  static const FontWeight thin = FontWeight.w100; //Thin
  static const FontWeight extraLight = FontWeight.w200; //ExtraLight
  static const FontWeight light = FontWeight.w300; //Light
  static const FontWeight regular = FontWeight.w400; //Regular
  static const FontWeight medium = FontWeight.w500; //Medium
  static const FontWeight semiBold = FontWeight.w600; //SemiBold
  static const FontWeight bold = FontWeight.w700; //Bold
  static const FontWeight extraBold = FontWeight.w800; //ExtraBold
  static const FontWeight black = FontWeight.w900; //Black


  static const double veryVerySmall = 10;
  static const double verySmall = 11;
  static const double small = 12;
  static const double routine = 14;
  static const double big = 16;
  static const double veryBig = 18;
  static const double veryVeryBig = 20;


  TextStyle labelTextLight = GoogleFonts.roboto(
    color: AppColors.black,
    fontWeight: medium,
    height: 1.5,
  );

  TextStyle bodyTextLight = GoogleFonts.roboto(
    color: AppColors.black,
    fontWeight: regular,
    height: 1.5,
  );

  TextStyle titleTextLight = GoogleFonts.roboto(
    color: AppColors.black,
    fontWeight: black,
    height: 1.5,
  );

  TextStyle displayTextLight = GoogleFonts.roboto(
    color: AppColors.black,
    fontWeight: semiBold,
    height: 1.5,
  );

  TextStyle headlineTextLight = GoogleFonts.roboto(
    color: AppColors.black,
    fontWeight: bold,
    height: 1.5,
  );


  //dark theme ---------------------------
  TextStyle labelTextDark = GoogleFonts.roboto(
    color: AppColors.white_00,
    fontWeight: medium,
    height: 1.5,
  );

  TextStyle bodyTextDark = GoogleFonts.roboto(
    color: AppColors.white_00,
    fontWeight: regular,
    height: 1.5,
  );

  TextStyle titleTextDark = GoogleFonts.roboto(
    color: AppColors.white_00,
    fontWeight: black,
    height: 1.5,
  );

  TextStyle displayTextDark = GoogleFonts.roboto(
    color: AppColors.white_00,
    fontWeight: semiBold,
    height: 1.5,
  );

  TextStyle headlineTextDark = GoogleFonts.roboto(
    color: AppColors.white_00,
    fontWeight: bold,
    height: 1.5,
  );

  static TextStyle inputText = (Get.textTheme.labelMedium??appFonts).copyWith(fontSize: routine);
  static TextStyle textHint = (Get.textTheme.labelMedium??appFonts).copyWith(fontSize: routine,color: AppColors.grey_10,fontWeight: light);
  static TextStyle textError = (Get.textTheme.bodyMedium??appFonts).copyWith(fontSize: routine,color: AppColors.red_55);

  static TextStyle appBarTitleStyle = (Get.textTheme.headlineMedium??appFonts).copyWith(fontSize: big);

  static TextStyle labelVeryVerySmall = (Get.textTheme.labelMedium??appFonts).copyWith(fontSize: veryVerySmall);
  static TextStyle labelVerySmall = (Get.textTheme.labelMedium??appFonts).copyWith(fontSize: verySmall);
  static TextStyle labelSmall = (Get.textTheme.labelMedium??appFonts).copyWith(fontSize: small,);
  static TextStyle labelMedium = (Get.textTheme.labelMedium??appFonts).copyWith(fontSize: routine);
  static TextStyle labelLarge = (Get.textTheme.labelMedium??appFonts).copyWith(fontSize: big);
  static TextStyle labelVeryLarge = (Get.textTheme.labelMedium??appFonts).copyWith(fontSize: veryBig);
  static TextStyle labelVeryVeryLarge = (Get.textTheme.labelMedium??appFonts).copyWith(fontSize:veryVeryBig);

  static TextStyle titleVeryVerySmall = (Get.textTheme.titleMedium??appFonts).copyWith(fontSize: veryVerySmall);
  static TextStyle titleVerySmall = (Get.textTheme.titleMedium??appFonts).copyWith(fontSize: verySmall);
  static TextStyle titleSmall = (Get.textTheme.titleMedium??appFonts).copyWith(fontSize: small);
  static TextStyle titleMedium = (Get.textTheme.titleMedium??appFonts).copyWith(fontSize: routine);
  static TextStyle titleLarge = (Get.textTheme.titleMedium??appFonts).copyWith(fontSize: big);
  static TextStyle titleVeryLarge = (Get.textTheme.titleMedium??appFonts).copyWith(fontSize: veryBig);
  static TextStyle titleVeryVeryLarge = (Get.textTheme.titleMedium??appFonts).copyWith(fontSize: veryVeryBig,);

  static TextStyle bodyVeryVerySmall = (Get.textTheme.bodyMedium??appFonts).copyWith(fontSize: veryVerySmall);
  static TextStyle bodyVerySmall = (Get.textTheme.bodyMedium??appFonts).copyWith(fontSize: verySmall);
  static TextStyle bodySmall = (Get.textTheme.bodyMedium??appFonts).copyWith(fontSize: small);
  static TextStyle bodyMedium = (Get.textTheme.bodyMedium??appFonts).copyWith(fontSize: routine);
  static TextStyle bodyLarge = (Get.textTheme.bodyMedium??appFonts).copyWith(fontSize: big);
  static TextStyle bodyVeryLarge = (Get.textTheme.bodyMedium??appFonts).copyWith(fontSize: veryBig);
  static TextStyle bodyVeryVeryLarge = (Get.textTheme.bodyMedium??appFonts).copyWith(fontSize: veryVeryBig);

  static TextStyle displayVeryVerySmall = (Get.textTheme.displayMedium??appFonts).copyWith(fontSize: veryVerySmall);
  static TextStyle displayVerySmall = (Get.textTheme.displayMedium??appFonts).copyWith(fontSize: verySmall);
  static TextStyle displaySmall = (Get.textTheme.displayMedium??appFonts).copyWith(fontSize: small);
  static TextStyle displayMedium = (Get.textTheme.displayMedium??appFonts).copyWith(fontSize: routine);
  static TextStyle displayLarge = (Get.textTheme.displayMedium??appFonts).copyWith(fontSize: big);
  static TextStyle displayVeryLarge = (Get.textTheme.displayMedium??appFonts).copyWith(fontSize: veryBig);
  static TextStyle displayVeryVeryLarge = (Get.textTheme.displayMedium??appFonts).copyWith(fontSize: veryVeryBig);

  static TextStyle headlineVeryVerySmall = (Get.textTheme.headlineMedium??appFonts).copyWith(fontSize: veryVerySmall);
  static TextStyle headlineVerySmall = (Get.textTheme.headlineMedium??appFonts).copyWith(fontSize: verySmall);
  static TextStyle headlineSmall = (Get.textTheme.headlineMedium??appFonts).copyWith(fontSize: small);
  static TextStyle headlineMedium = (Get.textTheme.headlineMedium??appFonts).copyWith(fontSize: routine);
  static TextStyle headlineLarge = (Get.textTheme.headlineMedium??appFonts).copyWith(fontSize: big);
  static TextStyle headlineVeryLarge = (Get.textTheme.headlineMedium??appFonts).copyWith(fontSize: veryBig);
  static TextStyle headlineVeryVeryLarge = (Get.textTheme.headlineMedium??appFonts).copyWith(fontSize: veryVeryBig);
}
