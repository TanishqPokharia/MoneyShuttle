import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

final scanResultProvider = StateProvider<Barcode?>((ref) {
  return null;
});
