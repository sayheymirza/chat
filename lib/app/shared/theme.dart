import 'package:flutter/material.dart';

Color seed = const Color(0xff985BFF);
String fontFamily = "YekanBakh";

ThemeData themeData = ThemeData(
  fontFamily: fontFamily,
// Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: seed,
    primary: seed,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: seed,
    unselectedItemColor: Colors.grey,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    // border top to black 1px of bottom navigation bar
    type: BottomNavigationBarType.fixed,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(100, 48)),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 14,
        ),
      ),
      backgroundColor: WidgetStateProperty.all(seed),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(100, 48)),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 14,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(100, 48)),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 14,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
    ),
  ),
  sliderTheme: SliderThemeData(
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7.0),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 10.0),
  ),
  // dropdown menu background to white
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  ),
);
