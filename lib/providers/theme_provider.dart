import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = FutureProvider((ref) async {
  final sharedPrefereces = await SharedPreferences.getInstance();
  int theme = sharedPrefereces.getInt("theme") ?? 0;
  switch (theme) {
    case 0:
      return ThemeMode.dark;
    case 1:
      return ThemeMode.light;
    case 2:
      return ThemeMode.system;
    default:
      return ThemeMode.system;
  }
});
