import 'package:cash_swift/extensions.dart';
import 'package:cash_swift/providers/qr_scan/qr_scan_notifier.dart';
import 'package:cash_swift/providers/qr_scan/qr_view_controller.dart';
import 'package:cash_swift/themes/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
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
  final qrKey = GlobalKey(debugLabel: "QR");

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ref.read(qrViewControllerProvider)?.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    ref.read(qrViewControllerProvider)!.pauseCamera();
    ref.read(qrViewControllerProvider)!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBackgroundColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Scan QR",
            style: context.textLarge,
          ),
        ),
        body: Container(
          color: appBackgroundColor,
          width: context.screenWidth,
          height: context.screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: (controller) {
                    ref
                        .read(qrScanNotifierProvider.notifier)
                        .onQrViewCreated(controller, ref);
                  },
                  formatsAllowed: [BarcodeFormat.qrcode],
                  overlay: QrScannerOverlayShape(
                      borderColor: Colors.green,
                      borderWidth: context.rSize(20),
                      borderLength: context.rSize(50),
                      cutOutSize: context.rSize(300)),
                ),
              ),
              Container(
                height: context.rSize(200),
                margin: EdgeInsets.symmetric(horizontal: context.rSize(150)),
                child: Center(
                  child: TextButton(
                      onPressed: () async {
                        await ref.read(qrViewControllerProvider)!.toggleFlash();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(Icons.flashlight_on),
                          Text(
                            "Flash",
                            style: context.textMedium,
                          ),
                        ],
                      )),
                ),
              )
            ],
          ),
        ));
  }
}
