import 'dart:io';

import 'package:cash_swift/main.dart';
import 'package:cash_swift/models/cash_swift_user.dart';
import 'package:cash_swift/providers/home/cash_swift_id_verification_provider.dart';
import 'package:cash_swift/providers/qr_scan/qr_view_controller.dart';
import 'package:cash_swift/providers/qr_scan/scan_result_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanScreen extends ConsumerStatefulWidget {
  const QRScanScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return QRScanScreenState();
  }
}

class QRScanScreenState extends ConsumerState<QRScanScreen> {
  double mq(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * (size / 1000);
  }

  final qrKey = GlobalKey(debugLabel: "QR");

  void onQrViewCreated(QRViewController controller, WidgetRef ref) {
    ref.read(qrViewControllerProvider.notifier).state = controller;
    controller.scannedDataStream.listen((event) {
      ref.read(scanResultProvider.notifier).state = event;
      onScanSuccessful();
    });
  }

  void onScanSuccessful() async {
    if (ref.read(scanResultProvider) != null) {
      await ref
          .read(cashSwiftIDVerifyProvider.notifier)
          .verifyCashSwiftID(ref.read(scanResultProvider)!.code!);

      if (ref.read(cashSwiftIDVerifyProvider) != null && mounted) {
        GoRouter.of(context).go("/home/payment/transaction",
            extra: ref.read(cashSwiftIDVerifyProvider));
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ref.read(qrViewControllerProvider)?.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    ref.watch(qrViewControllerProvider)!.pauseCamera();
    ref.watch(qrViewControllerProvider)!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final scanResult = ref.watch(scanResultProvider);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBackgroundColor,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              "Scan QR",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: Container(
            color: appBackgroundColor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: (controller) {
                      onQrViewCreated(controller, ref);
                    },
                    formatsAllowed: [BarcodeFormat.qrcode],
                    overlay: QrScannerOverlayShape(
                        borderColor: Colors.green,
                        borderWidth: mq(context, 20),
                        borderLength: mq(context, 50),
                        cutOutSize: mq(context, 300)),
                  ),
                ),
                Container(
                  height: mq(context, 200),
                  margin: EdgeInsets.symmetric(horizontal: mq(context, 150)),
                  child: Center(
                    // child: (scanResult != null)
                    //     ? Text(
                    //         'Barcode Type: ${(scanResult.format).name}   Data: ${scanResult.code}')
                    //     : Text('Scan a code'),
                    child: TextButton(
                        onPressed: () async {
                          await ref
                              .watch(qrViewControllerProvider)!
                              .toggleFlash();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.flashlight_on),
                            Text(
                              "Flash",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        )),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
