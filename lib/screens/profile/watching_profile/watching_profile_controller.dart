import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/network/auth_apis.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_screen.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_screen.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../main.dart';
import '../../eighteen_plus/eighteen_plus_card.dart';
import '../../auth/model/login_response.dart';
import '../../home/home_controller.dart';
import '../../subscription/subscription_screen.dart';
import 'components/add_update_profile_dialog_component.dart';
import 'model/profile_watching_model.dart';

class WatchingProfileController extends GetxController {
  bool navigateToDashboard;

  WatchingProfileController({this.navigateToDashboard = false});

  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  RxBool isLastPage = false.obs;
  RxBool isBtnEnable = false.obs;

  RxInt currentPage = 1.obs;
  Rx<Future<RxList<WatchingProfileModel>>> getProfileFuture = Future(() => RxList<WatchingProfileModel>()).obs;

  final TextEditingController saveNameController = TextEditingController();
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var selectedImagePath = ''.obs;
  var centerImagePath = ''.obs;
  var centerAssertImagePath = ''.obs;
  Rx<File> imageFile = File("").obs;
  XFile? pickedFile;

  Rx<WatchingProfileModel> selectedProfile = WatchingProfileModel().obs;

  List<String> defaultProfileImage = [
    Assets.watchingProfileDefaultAvatar1,
    Assets.watchingProfileDefaultAvatar2,
    Assets.watchingProfileDefaultAvatar3,
    Assets.watchingProfileDefaultAvatar4,
    Assets.watchingProfileDefaultAvatar5,
  ];

  RxInt page = 1.obs;

  RxInt currentIndex = 2.obs; // To track the middle index dynamically

  bool isChildProfile = true;
  RxBool isChildrenProfileEnabled = false.obs;

  var pin = ''.obs; // Stores the entered PIN

  /// Function to update the PIN when user enters values
  void updatePin(String value) {
    pin.value = value;
  }

  PageController pageController = PageController(
    initialPage: 2,
    viewportFraction: 0.30,
    keepPage: true,
  ); // Start with center image
  @override
  Future<void> onInit() async {
    super.onInit();
    currentIndex = 2.obs; // To track the middle index dynamically
    init();
    centerImagePath.value = Assets.iconsIcUser;
  }

  Future<void> init() async {
    isLoggedIn(getBoolAsync(SharedPreferenceConst.IS_LOGGED_IN));
    if (isLoggedIn.value) {
      final userData = getStringAsync(SharedPreferenceConst.USER_DATA);
      if (getStringAsync(SharedPreferenceConst.USER_DATA).isNotEmpty) {
        loginUserData(UserData.fromJson(jsonDecode(userData)));
      }
      getProfilesList();
    }
  }

  void getBtnEnable() {
    if (saveNameController.text.isNotEmpty) {
      isBtnEnable(true);
    } else {
      isBtnEnable(false);
    }
  }

  void updateCenterImage(String imagePath) {
    centerImagePath.value = imagePath;
  }

  ImageProvider<Object> getImageProvider(
    String imagePath, {
    double? height,
    double? width,
  }) {
    if (imagePath.startsWith('http') || Uri.tryParse(imagePath)?.isAbsolute == true) {
      // It's a network image
      return NetworkImage(
        '$imagePath?v=${DateTime.now().millisecondsSinceEpoch}',
      );
    } else if (File(imagePath).existsSync()) {
      // It's a valid local file
      return FileImage(File(imagePath));
    } else {
      // Invalid image path, return a placeholder or default image
      // Use a local asset as default
      return AssetImage(imagePath);
    }
  }

  Future<void> getProfilesList({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }

    await getProfileFuture(
      CoreServiceApis.getWatchingProfileList(
        profileList: accountProfiles,
        page: page.value,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    )
        .then((v) {
          if (profileId.value > 0 && accountProfiles.isNotEmpty && accountProfiles.any((element) => element.id == profileId.value)) {
            selectedProfile(accountProfiles.firstWhere((element) => element.id == profileId.value));
            selectedAccountProfile(selectedProfile.value);
          }
        })
        .whenComplete(() => isLoading(false))
        .catchError((e) {
          toast(e.toString());
          throw e;
        });
  }

  String generateRandomString() {
    final random = Random();
    const length = 10;
    const digits = '0123456789';

    return List.generate(length, (index) => digits[random.nextInt(digits.length)]).join();
  }

  Future<void> editUserProfile(bool isEdit, {required String name}) async {
    if (isLoading.isTrue) return;
    isLoading(true);
    File? tempFile;

    try {
      if (centerImagePath.value.startsWith("http")) {
        // Download the image from the network and store it in a temporary file
        final response = await http.get(Uri.parse(centerImagePath.value));
        if (response.statusCode == 200) {
          Directory tempDir = await getTemporaryDirectory();
          String tempPath = '${tempDir.path}/downloaded_image.png';
          tempFile = File(tempPath);
          await tempFile.writeAsBytes(response.bodyBytes);
        } else {
          throw Exception("Failed to download image");
        }
      } else {
        // Check if the file exists in the given path
        if (await File(centerImagePath.value).exists()) {
          tempFile = File(centerImagePath.value);
        } else {
          // Handle the case where the file does not exist or load asset image
          ByteData byteData = await rootBundle.load(centerImagePath.value);

          // Create a temporary file from the asset ByteData
          final buffer = byteData.buffer;
          Directory tempDir = await getTemporaryDirectory();
          String tempPath = '${tempDir.path}/temp_image.${generateRandomString()}.png';

          tempFile = File(tempPath)
            ..writeAsBytesSync(
              buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
            );
        }
      }

      // Prepare request data
      Map<String, dynamic> request = {
        "name": name,
        "is_child_profile": isChildrenProfileEnabled.value ? 1 : 0,
        "user_id": loginUserData.value.id,
      };

      if (isEdit) request.putIfAbsent("id", () => selectedProfile.value.id);

      // Send the profile update request with the image
      await CoreServiceApis.updateWatchProfile(
        request: request,
        files: [tempFile], // Use the file (downloaded or asset-based)
      ).then((value) async {
        if (value.newUserProfile.id > -1) {
          accountProfiles.clear();
          if (isEdit) {
            accountProfiles.removeWhere((element) => element.id == selectedProfile.value.id);
          }
          accountProfiles.addAll(value.data);
          selectedProfile(accountProfiles.firstWhere((element) => element.id == value.newUserProfile.id));
        } else {
          await getProfilesList();
        }
        successSnackBar(isEdit ? locale.value.profileUpdatedSuccessfully : locale.value.newProfileAddedSuccessfully);
      }).catchError((e) {
        isLoading(false);
        if (e is Map<String, dynamic>) {
          errorSnackBar(error: e['error']);
          if (e['status_code'] == 406) {
            Future.delayed(
              Duration(seconds: 1),
              () {
                Get.to(() => SubscriptionScreen(launchDashboard: false), preventDuplicates: false);
              },
            );
          }
        } else {
          errorSnackBar(error: e);
        }
      });
    } catch (e) {
      toast('Error: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteUserProfile(String id, {bool isFromProfileWatching = false}) async {
    if (isLoading.isTrue) return;
    isLoading(true);
    Map<String, dynamic> request = {"profile_id": id};
    await CoreServiceApis.deleteWatchingProfile(request: request).then((value) async {
      if (id.toInt() == profileId.value && !isFromProfileWatching) {
        profilePin('');
        selectedAccountProfile(WatchingProfileModel());
        Get.offAll(() => WatchingProfileScreen(), arguments: true);
      }
      await getProfilesList();
      toast(locale.value.profileDeletedSuccessfully);
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() => isLoading(false));
  }

  Future<void> handleSelectProfile(WatchingProfileModel profile) async {
    AuthServiceApis.removeCacheData();
    profileId(profile.id);
    selectedAccountProfile(profile);
    profilePin(profile.profilePin);

    isChildrenProfileEnabled.value = profile.isChildProfile == 1 ? true : false;
    setValue(SharedPreferenceConst.IS_PROFILE_ID, profile.id);

    if (navigateToDashboard.validate()) {
      // Clear and delete old DashboardController
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().clearCache();
        Get.delete<HomeController>();
      }
      Get.offAll(
        () => DashboardScreen(dashboardController: Get.put(DashboardController())),
        binding: BindingsBuilder(() {
          getDashboardController().onBottomTabChange(0);
        }),
      );
    } else {
      Get.back();
      Get.back();
    }
    if (!getBoolAsync(SharedPreferenceConst.IS_18_PLUS)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.bottomSheet(isDismissible: false, EighteenPlusCard());
      });
    }
  }

  void handleAddEditProfile(WatchingProfileModel profile, bool isEdit) {
    if (isEdit) {
      selectedProfile(profile);
      saveNameController.text = selectedProfile.value.name;
      updateCenterImage(profile.avatar);
      isChildrenProfileEnabled.value = profile.isChildProfile == 1 ? true : false;
    }
    Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: false,
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: AddUpdateProfileDialogComponent(isEdit: isEdit),
      ),
    ).then((v) {
      Get.back();
      saveNameController.clear();
    });
  }

  Future<void> logoutCurrentUser() async {
    isLoading(true);
    Get.back();

    await AuthServiceApis.deviceLogoutApi(deviceId: yourDevice.value.deviceId).then((value) async {
      isLoggedIn(false);
      AuthServiceApis.removeCacheData();
      await AuthServiceApis.clearData();
      successSnackBar(locale.value.youHaveBeenLoggedOutSuccessfully);
      removeKey(SharedPreferenceConst.IS_LOGGED_IN);

      Get.offAll(
        () => DashboardScreen(dashboardController: getDashboardController()),
        binding: BindingsBuilder(
          () {
            Get.put(HomeController());
          },
        ),
      );

      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }
}