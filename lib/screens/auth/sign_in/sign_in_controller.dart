// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_controller.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_screen.dart';

import 'package:streamit_laravel/network/auth_apis.dart';
import '../../../configs.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/country_picker/country_code.dart';
import '../../../utils/firebase_phone_auth/firebase_auth_util.dart';
import '../../../utils/firebase_phone_auth/firebase_excauth_exception_utils.dart';
import '../components/device_list_component.dart';
import '../components/otp_verify_component.dart';
import '../model/error_model.dart';
import '../services/social_logins.dart';
import '../sign_up/signup_screen.dart';

class SignInController extends GetxController {
  final GlobalKey<FormState> signInformKey = GlobalKey();

  RxBool isPhoneAuthLoading = false.obs;
  RxBool isOTPSent = false.obs;
  RxBool isVerifyBtn = false.obs;
  RxBool isBtnEnable = false.obs;
  RxBool isRememberMe = true.obs;
  RxBool isLoading = false.obs;
  RxBool isNormalLogin = false.obs;

  RxString countryCode = "+91".obs;
  RxBool isOTPVerify = false.obs;

  Rx<String> verificationCode = ''.obs;
  Rx<String> verificationId = ''.obs;
  Rx<String> mobileNo = ''.obs;
  Rx<Timer> codeResendTimer = Timer(const Duration(), () {}).obs;
  Rx<int> codeResendTime = 0.obs;

  set setCodeResendTime(int time) {
    codeResendTime(time);
  }

  TextEditingController phoneCont = TextEditingController();
  TextEditingController countryCodeCont = TextEditingController();
  TextEditingController verifyCont = TextEditingController();

  Rx<Country> selectedCountry = defaultCountry.obs;

  FocusNode phoneFocus = FocusNode();
  FocusNode countryCodeFocus = FocusNode();

  TextEditingController emailCont = TextEditingController(text: Constants.DEFAULT_EMAIL);
  TextEditingController passwordCont = TextEditingController(text: Constants.DEFAULT_PASS);

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void onInit() {
    init();
    getBtnEnable();
    super.onInit();
  }

  Future<void> init() async {
    if (await isIqonicProduct) {
      phoneCont.text = Constants.demoNumber;
      getBtnEnable();
    }
  }

  void getBtnEnable() {
    if (phoneCont.text.isNotEmpty && phoneCont.text.isNotEmpty) {
      isBtnEnable(true);
    } else {
      isBtnEnable(false);
    }
  }

  void getVerifyBtnEnable() {
    if (verifyCont.text.isNotEmpty && verifyCont.text.length == 6) {
      hideKeyBoardWithoutContext();
      isVerifyBtn(true);
    } else {
      isVerifyBtn(false);
    }
  }

  Future<void> isDemoUser({bool verify = false}) async {
    isLoading(true);

    Future.delayed(
      Duration(seconds: 2),
      () {
        if (verify) {
          isOTPVerify(true);
          isLoading(false);
          phoneSignIn();
        } else {
          isOTPSent(true);
          verificationId('');
          mobileNo(phoneCont.text);
          countryCode(countryCode.value);
          initializeCodeResendTimer;
          isLoading(false);
          Get.bottomSheet(
            isDismissible: false,
            isScrollControlled: false,
            enableDrag: false,
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: OTPVerifyComponent(
                mobileNo: "$countryCode${phoneCont.text}",
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> checkIfDemoUser({bool verify = false, required VoidCallback callBack}) async {
    if (phoneCont.text.trim() == Constants.demoNumber) {
      verificationCode('123456');
      verifyCont.text = '123456';
      isOTPVerify(true);
      isDemoUser(verify: verify);
    } else {
      callBack.call();
    }
  }

  Future<void> onLoginPressed() async {
    isLoading(true);
    isOTPSent(false);
    final firebaseAuthUtil = FirebaseAuthUtil();

    try {
      firebaseAuthUtil.login(
          mobileNumber: "$countryCode${phoneCont.text}",
          onCodeSent: (value) {
            isOTPSent(true);
            verificationId(value);
            mobileNo(phoneCont.text);
            countryCode(countryCode.value);
            initializeCodeResendTimer;
            isLoading(false);
            Get.bottomSheet(
              isDismissible: false,
              isScrollControlled: false,
              enableDrag: false,
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: OTPVerifyComponent(
                  mobileNo: "$countryCode${phoneCont.text}",
                ),
              ),
            );
          },
          onVerificationFailed: (value) {
            isOTPSent(false);
            isPhoneAuthLoading(false);
            isLoading(false);
            errorSnackBar(error: FirebaseAuthHandleExceptionsUtils().handleException(value));
          });
    } catch (e) {
      isLoading(false);
      isOTPSent(false);
      errorSnackBar(error: e);
    }
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
          prefixIcon: const Icon(
            Icons.search,
            color: white,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: white,
            ),
          ),
        ),
      ),

      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        countryCode("+${country.phoneCode}");
        selectedCountry(country);
      },
    );
  }

  Future<void> loginAPICall({required Map<String, dynamic> request, required bool isSocialLogin, bool isNormalLogin = false}) async {
    await AuthServiceApis.loginUser(request: request, isSocialLogin: isSocialLogin).then((value) async {
      handleLoginResponse(isSocialLogin: isSocialLogin, isNormalLogin: isNormalLogin);
    }).catchError((e) async {
      if (e.toString().startsWith('404')) {
        Get.offAll(() => SignUpScreen(), arguments: [true, mobileNo, countryCode]);
      } else {
        isLoading(false);
        if (!isNormalLogin) {
          Get.back();
        }
        errorSnackBar(error: e);
        if (e is Map<String, dynamic> && e.containsKey('status_code') && e['status_code'] == 406 && e.containsKey('response')) {
          ErrorModel errorData = ErrorModel.fromJson(e['response']);
          Get.bottomSheet(
            isDismissible: true,
            isScrollControlled: true,
            enableDrag: false,
            DeviceListComponent(
              loggedInDeviceList: errorData.otherDevice,
              onLogout: (logoutAll, deviceId, deviceName) {
                Get.back();
                if (logoutAll) {
                  logOutAll(errorData.otherDevice.first.userId);
                } else {
                  deviceLogOut(device: deviceId, userId: errorData.otherDevice.first.userId.toInt());
                }
              },
            ),
          ).then((value) {
            Get.back();
          });
        }
      }
    });
  }

  Future<void> saveForm({bool isNormalLogin = false}) async {
    if (isLoading.isTrue) return;

    hideKeyBoardWithoutContext();
    isLoading(true);
    Map<String, dynamic> req = {
      'email': emailCont.text.trim(),
      'password': passwordCont.text.trim(),
      'device_id': yourDevice.value.deviceId,
      'device_name': yourDevice.value.deviceName,
      'platform': yourDevice.value.platform,
    };

    await loginAPICall(isSocialLogin: false, request: req, isNormalLogin: isNormalLogin);
  }

  Future<void> phoneSignIn() async {
    if (isLoading.value) return;

    isLoading(true);
    Map<String, dynamic> request = {
      UserKeys.username: "${countryCode.value}${mobileNo.value.trim()}",
      UserKeys.password: "${countryCode.value}${mobileNo.value.trim()}",
      UserKeys.mobile: "${countryCode.value}${mobileNo.value.trim()}",
      'device_id': yourDevice.value.deviceId,
      'device_name': yourDevice.value.deviceName,
      'platform': yourDevice.value.platform,
      UserKeys.loginType: LoginTypeConst.LOGIN_TYPE_OTP,
    };

    await loginAPICall(isSocialLogin: true, request: request);
  }

  void get initializeCodeResendTimer {
    codeResendTimer.value.cancel();
    codeResendTime(60);
    codeResendTimer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (codeResendTime > 0) {
        setCodeResendTime = --codeResendTime.value;
      } else {
        timer.cancel();
      }
    });
  }

  void onVerifyPressed() async {
    final firebaseAuthUtil = FirebaseAuthUtil();
    isLoading(true);
    isVerifyBtn(false);
    try {
      await firebaseAuthUtil.verifyOTPCode(
          verificationId: verificationId.value,
          verificationCode: verifyCont.text,
          onVerificationSuccess: (value) {
            log("Phone Auth Completed");
            isOTPVerify(true);
            isLoading(false);
            phoneSignIn();
          },
          onCodeVerificationFailed: (value) {
            isLoading(false);
            verifyCont.clear();

            Get.back();
            Get.bottomSheet(
              isDismissible: false,
              isScrollControlled: false,
              enableDrag: false,
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: OTPVerifyComponent(
                  mobileNo: mobileNo.value,
                ),
              ),
            );
            errorSnackBar(error: value);
          });
    } catch (error) {
      isLoading(false);
      verifyCont.clear();

      Get.back();
      Get.bottomSheet(
        isDismissible: false,
        isScrollControlled: false,
        enableDrag: false,
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: OTPVerifyComponent(
            mobileNo: mobileNo.value,
          ),
        ),
      );
      errorSnackBar(error: error);
    }
  }

  Future<void> reSendOTP() async {
    if (isLoading.value) {
      return;
    }
    final firebaseAuthUtil = FirebaseAuthUtil();
    isLoading(true);
    firebaseAuthUtil.login(
        mobileNumber: "${countryCode.value}${mobileNo.value}",
        onCodeSent: (value) {
          initializeCodeResendTimer;
          isLoading(false);
          verificationId(value);
        },
        onVerificationFailed: (value) {
          isLoading(false);
          verifyCont.clear();
          errorSnackBar(error: FirebaseAuthHandleExceptionsUtils().handleException(value));
        });
  }

  Future<void> googleSignIn() async {
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.first == ConnectivityResult.none) {
      toast(locale.value.yourInternetIsNotWorking, print: true);
      return;
    }

    isLoading(true);
    await GoogleSignInAuthService.signInWithGoogle().then((value) async {
      Map<String, dynamic> request = {
        UserKeys.email: value.email,
        UserKeys.password: value.email,
        UserKeys.firstName: value.firstName,
        UserKeys.lastName: value.lastName,
        UserKeys.mobile: value.mobile,
        UserKeys.fileUrl: value.profileImage,
        'device_id': yourDevice.value.deviceId,
        'device_name': yourDevice.value.deviceName,
        'platform': yourDevice.value.platform,
        UserKeys.loginType: LoginTypeConst.LOGIN_TYPE_GOOGLE,
      };
      log('signInWithGoogle REQUEST: $request');

      await loginAPICall(request: request, isSocialLogin: true);
    }).catchError((e) {
      isLoading(false);
      log("Error is $e");
      toast(e.toString(), print: true);
    });
  }

  Future<void> appleSignIn() async {
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.first == ConnectivityResult.none) {
      toast(locale.value.yourInternetIsNotWorking, print: true);
      return;
    }
    isLoading(true);
    await GoogleSignInAuthService.signInWithApple().then((value) async {
      Map<String, dynamic> request = {
        UserKeys.email: value.email,
        UserKeys.password: value.email,
        UserKeys.firstName: value.firstName,
        UserKeys.lastName: value.lastName,
        UserKeys.mobile: value.mobile,
        UserKeys.fileUrl: value.profileImage,
        'device_id': yourDevice.value.deviceId,
        'device_name': yourDevice.value.deviceName,
        'platform': yourDevice.value.platform,
        UserKeys.loginType: LoginTypeConst.LOGIN_TYPE_APPLE,
      };
      log('signInWithGoogle REQUEST: $request');

      /// Social Login Api
      await loginAPICall(request: request, isSocialLogin: true);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }

  void handleLoginResponse({String? password, bool isSocialLogin = false, bool isNormalLogin = false}) {
    try {
      setValue(SharedPreferenceConst.USER_PASSWORD, isSocialLogin ? "" : passwordCont.text.trim());
      setValue(SharedPreferenceConst.IS_LOGGED_IN, true);
      setValue(SharedPreferenceConst.IS_REMEMBER_ME, isRememberMe.value);

       Get.offAll(() => WatchingProfileScreen(), binding: BindingsBuilder(() {
          Get.isRegistered<WatchingProfileController>() ? Get.find<WatchingProfileController>() : Get.put(WatchingProfileController(navigateToDashboard: true));
        }));

      isLoading(false);
    } catch (e) {
      log("Error  ==> $e");
    }
  }

  Future<void> deviceLogOut({required String device, required int userId}) async {
    removeKey(SharedPreferenceConst.IS_PROFILE_ID);
    isLoading(true);
    await AuthServiceApis.deviceLogoutApiWithoutAuth(deviceId: device, userId: userId).then((value) {
      successSnackBar(value.message);
      // Close bottom sheet after success
      if (Get.isBottomSheetOpen ?? false) Get.back();
    }).catchError((e) {
      errorSnackBar(error: e);
      // Close bottom sheet after error
      if (Get.isBottomSheetOpen ?? false) Get.back();
    }).whenComplete(() {
      isLoading(false);
    });
  }

  Future<void> logOutAll(int userId) async {
    Get.back();
    if (isLoading.value) return;
    isLoading(true);
    await AuthServiceApis.logOutAllAPIWithoutAuth(userId: userId).then((value) async {
      successSnackBar(value.message);
      Get.back();
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() {
      isLoading(false);
    });
  }
}