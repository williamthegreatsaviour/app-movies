// ignore_for_file: depend_on_referenced_packages

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/network/auth_apis.dart';
import 'package:streamit_laravel/screens/auth/sign_in/sign_in_controller.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_screen.dart';

import '../../../configs.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/country_picker/country_code.dart';
import '../sign_in/sign_in_screen.dart';

enum Gender { male, female, other }

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isBtnEnable = false.obs;
  RxBool isPhoneAuth = false.obs;
  RxString countryCode = "+91".obs;
  final GlobalKey<FormState> signUpFormKey = GlobalKey();

  var selectedGender = Gender.male.obs;

  RxBool agree = false.obs;
  RxBool isAcceptedTc = false.obs;

  TextEditingController emailCont = TextEditingController();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confPasswordCont = TextEditingController();
  TextEditingController userTypeCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController dobCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confPasswordFocus = FocusNode();
  FocusNode userTypeFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode dobFocus = FocusNode();

  Rx<Country> selectedCountry = defaultCountry.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      if (Get.arguments[0] is bool) {
        isPhoneAuth(true);
      }
      if (Get.arguments[1] is RxString) {
        mobileCont.text = Get.arguments[1].value;
        passwordCont.text = Get.arguments[1].value;
        confPasswordCont.text = Get.arguments[1].value;
      }
      if (Get.arguments[2] is RxString) {
        countryCode.value = Get.arguments[2].value;

        mobileCont.text = mobileCont.text.prefixText(value: countryCode.value);
      }
    }
    super.onInit();
  }

  void setGender(Gender gender) {
    selectedGender.value = gender;
  }

  Future<void> saveForm() async {
    if (isLoading.isTrue) return;
    isLoading(true);
    hideKeyBoardWithoutContext();
    Map<String, dynamic> req;
    if (isPhoneAuth.isTrue) {
      req = {
        "email": emailCont.text.trim(),
        "first_name": firstNameCont.text.trim(),
        "last_name": lastNameCont.text.trim(),
        "password": mobileCont.text.trim(),
        "mobile": mobileCont.text.trim(),
        "gender":selectedGender.value.name,
        UserKeys.username: mobileCont.text.trim(),
        UserKeys.loginType: LoginTypeConst.LOGIN_TYPE_OTP,
      };
    } else {
      req = {
        "email": emailCont.text.trim(),
        "first_name": firstNameCont.text.trim(),
        "last_name": lastNameCont.text.trim(),
        "password": passwordCont.text.trim(),
        "mobile": "${countryCode.value}${mobileCont.text.trim()}",
        "gender":selectedGender.value.name,
        "date_of_birth": dobCont.value.text.toString(),
        "confirm_password": confPasswordCont.text.trim(),
      };
    }

    await AuthServiceApis.createUser(request: req).then((value) async {
      if (isPhoneAuth.isTrue) {
        final SignInController verificationController = Get.put(SignInController());
        verificationController.mobileNo(mobileCont.text.trim().splitAfter(countryCode.value));
        verificationController.phoneSignIn();
      } else {
        try {
          Map<String, dynamic> req = {
            'email': emailCont.text.trim(),
            'password': passwordCont.text.trim(),
            'device_id': yourDevice.value.deviceId,
            'device_name': yourDevice.value.deviceName,
            'platform': yourDevice.value.platform,
          };

          await AuthServiceApis.loginUser(request: req).then((value) async {
            handleLoginResponse();
          }).whenComplete(() {
            isLoading(false);
          }).catchError((e) {
            isLoading(false);
            Get.to(() => SignInScreen());
          });
        } catch (e) {
          log('E: $e');
          toast(e.toString(), print: true);
        }
        Get.back();
        toast(value, print: true);
      }
    }).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
  }

  void onBtnEnable() {
    if (mobileCont.text.isNotEmpty && firstNameCont.text.isNotEmpty && lastNameCont.text.isNotEmpty && emailCont.text.isNotEmpty && passwordCont.text.isNotEmpty && confPasswordCont.text.isNotEmpty) {
      isBtnEnable(true);
    } else {
      isBtnEnable(false);
    }
  }

  void onClear() {
    firstNameCont.clear();
    lastNameCont.clear();
    emailCont.clear();
    passwordCont.clear();
    confPasswordCont.clear();
    isBtnEnable(false);
  }

  @override
  void onClose() {
    firstNameCont.clear();
    lastNameCont.clear();
    emailCont.clear();
    passwordCont.clear();
    confPasswordCont.clear();
    mobileCont.clear();
    dobCont.clear();

    super.onClose();
  }

  Future<void> changeCountry(BuildContext context) async {
    showCustomCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        margin: const EdgeInsets.only(top: 80),
        bottomSheetHeight: Get.height * 0.86,
        backgroundColor: btnColor,
        padding: const EdgeInsets.only(top: 12, left: 4, right: 4),
        textStyle: secondaryTextStyle(color: white),
        searchTextStyle: primaryTextStyle(color: white),
        inputDecoration: InputDecoration(
          labelStyle: secondaryTextStyle(color: white),
          labelText: locale.value.searchHere,
          prefixIcon: const Icon(Icons.search, color: white),
          border: const OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: white)),
        ),
      ),

      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        countryCode("+${country.phoneCode}");
        selectedCountry(country);
        log(country.flagEmoji);
      },
    );
  }

  void handleLoginResponse({String? password, bool isSocialLogin = false}) {
    try {
      Get.offAll(() => WatchingProfileScreen());
      isLoading(false);
    } catch (e) {
      log("Error  ==> $e");
    }
  }
}