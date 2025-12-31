import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AppColors.dart';
import 'AppTextStyle.dart';

class CustomTheme {

  // light theme
  static final lightTheme = ThemeData(
    primaryColor: AppColors.black,
    primaryColorLight: AppColors.white_00,
    primaryColorDark: AppColors.white_90,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
    ),
    scrollbarTheme: ScrollbarThemeData(
      trackVisibility: WidgetStatePropertyAll(false)
    ),
    drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.white_00
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.black,
      selectionColor: AppColors.grey_09,
      selectionHandleColor: AppColors.black,
    ),
    scaffoldBackgroundColor: AppColors.primaryBackGroundColor,
    fontFamily: GoogleFonts.notoSans().fontFamily,
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.white_00,
      surfaceTintColor: AppColors.white_00,
    ),
    canvasColor: AppColors.white_00,
    textTheme: TextTheme(
      bodyMedium: AppTextStyle().bodyTextLight,
      headlineMedium: AppTextStyle().headlineTextLight,
      displayMedium: AppTextStyle().displayTextLight,
      labelMedium: AppTextStyle().labelTextLight,
      titleMedium: AppTextStyle().titleTextLight,
    ),
    cardTheme: const CardThemeData(
        color: AppColors.white_00,
        surfaceTintColor: AppColors.white_00
    ),
    switchTheme: SwitchThemeData(
      trackOutlineColor: MaterialStateProperty.all<Color>(AppColors.grey_10),
      thumbColor: const WidgetStatePropertyAll(AppColors.black),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryBackGroundColor,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700
      ),
      iconTheme: IconThemeData(color: AppColors.black),
      elevation: 0,
      titleSpacing: 5,
      actionsIconTheme: IconThemeData(color: AppColors.black),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.white_00,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
  );

  // dark theme
  static final darkTheme = ThemeData(
    primaryColor: AppColors.white_00,
    primaryColorLight: AppColors.primaryBackGroundColorDark,
    primaryColorDark: AppColors.darkThemeCardColor,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.primaryBackGroundColorDark,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.white_00,
      selectionColor: AppColors.white_00,
      selectionHandleColor: AppColors.white_00,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.darkThemeCardColor,
    ),
    fontFamily: GoogleFonts.notoSans().fontFamily,
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.white_00,
      surfaceTintColor: AppColors.white_00,
    ),
    canvasColor: AppColors.black,
    cardTheme: CardThemeData(
      color: AppColors.darkThemeCardColor,
      surfaceTintColor: AppColors.darkThemeCardColor,
    ),
    iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
            iconColor: WidgetStatePropertyAll(AppColors.white_00)
        )
    ),
    textTheme: TextTheme(
      bodyMedium: AppTextStyle().bodyTextDark,
      headlineMedium: AppTextStyle().headlineTextDark,
      displayMedium: AppTextStyle().displayTextDark,
      labelMedium: AppTextStyle().labelTextDark,
      titleMedium: AppTextStyle().titleTextDark,
    ),
    switchTheme: SwitchThemeData(
      trackOutlineColor: WidgetStateProperty.all<Color>(AppColors.grey_10),
      thumbColor: const WidgetStatePropertyAll(AppColors.white_00),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white_00,
      scrolledUnderElevation: 0,
      titleSpacing: 5,
      titleTextStyle: const TextStyle(
          color: AppColors.white_00,
          fontSize: 16,
          fontWeight: FontWeight.w700
      ),
      iconTheme: IconThemeData(color: AppColors.white_00),
      elevation: 0,
      actionsIconTheme: IconThemeData(color: AppColors.white_00),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.white_00,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
  );

}