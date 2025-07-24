import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constants.dart';

class EighteenPlusController extends GetxController {
  RxBool is18Plus = (getBoolAsync(SharedPreferenceConst.IS_18_PLUS)).obs;
}
