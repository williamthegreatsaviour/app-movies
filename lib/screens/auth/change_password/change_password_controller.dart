import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/auth/change_password/password_set_success.dart';

import '../../../main.dart';
import '../../../network/auth_apis.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';

class ChangePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isBtnEnable = false.obs;

  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newPasswordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  FocusNode oldPasswordFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  Future<void> saveForm() async {
    isLoading(true);

    if (getStringAsync(SharedPreferenceConst.USER_PASSWORD) != oldPasswordCont.text.trim()) {
      return toast(locale.value.yourOldPasswordDoesnT);
    } else if (newPasswordCont.text.trim() != confirmPasswordCont.text.trim()) {
      return toast(locale.value.yourNewPasswordDoesnT);
    } else if ((oldPasswordCont.text.trim() == newPasswordCont.text.trim()) && oldPasswordCont.text.trim() == confirmPasswordCont.text.trim()) {
      return toast(locale.value.oldAndNewPassword);
    }

    hideKeyBoardWithoutContext();

    Map<String, dynamic> req = {
      'old_password': getStringAsync(SharedPreferenceConst.USER_PASSWORD),
      'new_password': confirmPasswordCont.text.trim(),
    };

    await AuthServiceApis.changePasswordApi(request: req).then((value) async {
      isLoading(false);
      setValue(SharedPreferenceConst.USER_PASSWORD, confirmPasswordCont.text.trim());
      loginUserData.value.apiToken = value.data.apiToken;
      Get.to(() => const PasswordSetSuccess());
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }
}