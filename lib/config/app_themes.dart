import 'package:flutter/material.dart';

import 'app_colors.dart';

enum AppThemeOptions { light, dark }

class AppThemes {
  static ThemeData fromName(String name) {
    if (name == AppThemeOptions.light.name) {
      return lightTheme;
    }

    if (name == AppThemeOptions.dark.name) {
      return darkTheme;
    }

    throw Exception("not support this theme: $name");
  }

  static const TextStyle darkText = TextStyle(
    color: AppColors.whiteGrey,
    fontFamily: 'ManRope',
  );

  static const TextStyle lightText = TextStyle(
    color: AppColors.black,
    fontFamily: 'ManRope',
  );

  static final ThemeData darkTheme = ThemeData(
    colorSchemeSeed: AppColors.blue,
    brightness: Brightness.dark,
    fontFamily: 'ManRope',
    // -------------------
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    colorSchemeSeed: AppColors.blue,
    brightness: Brightness.light,
    fontFamily: 'ManRope',
    // ------------------
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
    ),
  );
}
