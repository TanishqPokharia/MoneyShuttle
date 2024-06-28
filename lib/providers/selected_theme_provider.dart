import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final selectedThemeProvider = FutureProvider((ref) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final selectedTheme = sharedPreferences.getInt("theme") ?? 0;
  return selectedTheme;
});
