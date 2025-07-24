import 'package:get/get.dart';

class RentDetailsController extends GetxController {
  RxBool isChecked = false.obs;

  @override
  void onClose() {
    isChecked.value = false; // Reset the checkbox state when the controller is closed
    super.onClose();
  }
}