import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_puzzle/config/app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  static const _KEY_THEME = 'key_dark_theme';

  static SharedPreferences? _prefs;

  ThemeData _themeData = AppThemes.lightTheme;
  bool useDarkTheme = false;

  ThemeData get themeData => _themeData;

  void init() async{
    _prefs ??= await SharedPreferences.getInstance();

    final value = _prefs!.getString(_KEY_THEME) ?? AppThemeOptions.light.name;

    if(value == AppThemeOptions.light.name){
      useDarkTheme = false;
    }else if(value == AppThemeOptions.dark.name){
      useDarkTheme = true;
    }

    _themeData = AppThemes.fromName(value);

    notifyListeners();
  }

  void switchTheme(AppThemeOptions theme) {
    switch (theme) {
      case AppThemeOptions.light:
        _themeData = AppThemes.lightTheme;
        _writeTheme(AppThemeOptions.light);
        useDarkTheme = false;
        break;
      case AppThemeOptions.dark:
        _themeData = AppThemes.darkTheme;
        _writeTheme(AppThemeOptions.dark);
        useDarkTheme = true;
        break;
    }
    notifyListeners();
  }

  Future<bool> _writeTheme(AppThemeOptions theme) async {
    final value = theme.name;

    _prefs ??= await SharedPreferences.getInstance();

    return await _prefs!.setString(_KEY_THEME, value);
  }
}
