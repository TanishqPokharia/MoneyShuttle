import 'package:cash_swift/providers/home/cash_swift_id_verification_provider.dart';
import 'package:cash_swift/providers/home/transaction_cleanup_notifier.dart';
import 'package:cash_swift/providers/qr_scan/qr_view_controller.dart';
import 'package:cash_swift/providers/qr_scan/scan_result_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

final qrScanNotifierProvider =
    StateNotifierProvider<QRScanNotifier, void>((ref) {
  return QRScanNotifier();
});

class QRScanNotifier extends StateNotifier<void> {
  QRScanNotifier() : super(());

  void onQrViewCreated(QRViewController controller, WidgetRef ref) {
    ref.read(qrViewControllerProvider.notifier).state = controller;
    controller.scannedDataStream.listen((event) {
      ref.read(scanResultProvider.notifier).state = event;
      onScanSuccessful(ref);
    });
  }

  void onScanSuccessful(WidgetRef ref) async {
    final context = useContext();
    print("success");
    if (ref.read(scanResultProvider) != null) {
      // splitting because custom qr will also contain the amount
      final String code = ref.read(scanResultProvider)!.code!;
      await ref
          .read(cashSwiftIDVerifyProvider.notifier)
          .verifyCashSwiftID(code.split("/").last, context);

      if (mounted) {
        ref
            .read(transactionCleanUpProvider.notifier)
            .cleanUpTransactionData(ref);
        GoRouter.of(context).push(
            "/home/scan/transaction?amount=${code.split("/").first}",
            extra: ref.read(cashSwiftIDVerifyProvider));
      }
    }
  }
}
