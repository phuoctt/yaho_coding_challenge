import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../share/constant.dart';

class UserLocalStorage {
  static const String themeKey = 'theme_key';

  late SharedPreferences _storage;

  Future<void> load() async {
    _storage = await SharedPreferences.getInstance();
    await loadTheme();
  }

  loadTheme() async {
    _themeMode = _storage.getString(themeKey) ?? ThemeCodes.light;
  }

  updateTheme(Brightness theme) {
    _scheduleSave(themeKey,
        theme == Brightness.light ? ThemeCodes.light : ThemeCodes.dark);
  }

  Brightness get theme => _getBrightness();
  String _themeMode = "";

  set themeMode(String value) {
    _themeMode = value;
    _scheduleSave(themeKey, value);
  }

  void _scheduleSave(String key, String value) {
    _storage.setString(key, value);
  }

  Brightness _getBrightness() =>
      _themeMode == ThemeCodes.light ? Brightness.light : Brightness.dark;
}
