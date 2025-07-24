import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../main.dart';
import '../../network/core_api.dart';
import '../../utils/common_base.dart';

class QRScannerController extends GetxController {
  RxBool isProcessing = false.obs;
  RxBool isLoading = false.obs;

  MobileScannerController scannerController = MobileScannerController(autoStart: true);

  void onDetect(BarcodeCapture capture) async {
    if (isProcessing.value) return;

    final String? sessionId = capture.barcodes.first.rawValue;
    if (sessionId == null) {
      return;
    }

    isProcessing(true);

    // QR Scan TV Link API
    isLoading(true);
    Map<String, dynamic> request = {"session_id": sessionId};
    await CoreServiceApis.linkTvAPI(request: request).then((value) async {
      successSnackBar(locale.value.tvLinkedSuccessfully);
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() {
      isProcessing(false);
      isLoading(false);
    });
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}