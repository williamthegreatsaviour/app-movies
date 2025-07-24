import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appScreenBackgroundDark,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      surfaceTintColor: appScreenBackgroundDark,
      color: appScreenBackgroundDark,
      iconTheme: const IconThemeData(color: whiteColor),
      titleTextStyle: TextStyle(
        color: primaryTextColor,
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light),
    ),
    primaryColor: appColorPrimary,
    dividerColor: canvasColor,
    iconTheme: IconThemeData(color: Colors.white),
    primaryColorDark: appColorPrimary,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white, selectionHandleColor: appColorPrimary),
    hoverColor: Colors.white,
    fontFamily: GoogleFonts.roboto().fontFamily,
    drawerTheme: const DrawerThemeData(backgroundColor: fullDarkCanvasColorDark),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: borderColor),
    primaryTextTheme: TextTheme(
      titleLarge: primaryTextStyle(
        color: primaryTextColor,
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
      labelSmall: primaryTextStyle(
        color: primaryTextColor,
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
    ),
    cardTheme: const CardThemeData(color: cardBackgroundBlackDark),
    cardColor: cardBackgroundBlackDark,
    textTheme: GoogleFonts.robotoFlexTextTheme(),
    tabBarTheme: const TabBarThemeData(indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Colors.white))),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(appColorPrimary),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
    }),
    colorScheme: const ColorScheme.dark(
      primary: appBackgroundColorDark,
      onPrimary: cardBackgroundBlackDark,
      secondary: whiteColor,
      error: Color(0xFFCF6676),
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: appScreenBackgroundDark,
      titleTextStyle: TextStyle(
        color: primaryTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: primaryTextColor,
        fontSize: 16,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: appColorPrimary,
      textTheme: ButtonTextTheme.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(boldTextStyle(color: appColorPrimary, size: 14, weight: FontWeight.w600)),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        overlayColor: WidgetStatePropertyAll(appColorPrimary.withValues(alpha: 0.2)),
        splashFactory: InkSparkle.splashFactory,
        shadowColor: WidgetStatePropertyAll(appColorPrimary.withValues(alpha: 0.2)),
      ),
    ),
  ).copyWith(
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: appColorPrimary),
  );
}