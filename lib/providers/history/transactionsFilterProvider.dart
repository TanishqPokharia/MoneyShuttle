import 'package:flutter_riverpod/flutter_riverpod.dart';

final monthFilterProvider = StateProvider<int>((ref) {
  return DateTime.now().month;
});

final yearFilterProvider = StateProvider<int>((ref) {
  return DateTime.now().year;
});
