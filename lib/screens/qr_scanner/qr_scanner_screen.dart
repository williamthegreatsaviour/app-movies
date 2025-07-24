import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/qr_scanner/qr_scanner_controller.dart';

import '../../components/app_scaffold.dart';
import '../../utils/colors.dart';

class QrScannerScreen extends StatelessWidget {
  QrScannerScreen({super.key});

  final QRScannerController qrScannerScreenController = QRScannerController();

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      scaffoldBackgroundColor: appScreenBackgroundDark,
      isLoading: qrScannerScreenController.isLoading,
      topBarBgColor: transparentColor,
      appBartitleText: 'Scan TV QR Code',
      body: MobileScanner(
        controller: qrScannerScreenController.scannerController,
        onDetect: (BarcodeCapture capture) {
          Get.back();
          qrScannerScreenController.onDetect(capture);
        },
      ),
    );
  }
}