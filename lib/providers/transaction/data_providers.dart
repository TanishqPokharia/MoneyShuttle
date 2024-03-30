import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentAmountProvider = StateProvider<String>((ref) => "");
final noteContentProvider = StateProvider<String>((ref) => "");
final noteStatusProvider = StateProvider<bool>((ref) => false);
