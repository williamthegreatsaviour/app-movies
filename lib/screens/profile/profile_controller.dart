import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/profile/model/profile_detail_resp.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

import '../../network/core_api.dart';
import '../../utils/constants.dart';
import '../subscription/model/subscription_plan_model.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isProfileLoggedIn = false.obs;
  Rx<Future<ProfileDetailResponse>> getProfileDetailsFuture = Future(() => ProfileDetailResponse(data: ProfileModel(planDetails: SubscriptionPlanModel()))).obs;
  Rx<ProfileModel> profileDetailsResp = ProfileModel(planDetails: SubscriptionPlanModel()).obs;

  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  RxString languageName = "".obs;

  Rx<Future<RxList<VideoPlayerModel>>> rentedContentFuture = Future(() => RxList<VideoPlayerModel>()).obs;
  RxList<VideoPlayerModel> rentedContentList = RxList();

  @override
  void onInit() {
    if (cachedProfileDetails != null) {
      profileDetailsResp(cachedProfileDetails?.data);
    }
    super.onInit();
    if (isLoggedIn.isTrue) {
      getProfile();
      getProfileDetail();
      getRentedContentDetails();
    }
  }

  void getProfile() {
    if (isLoggedIn.isTrue) {
      isProfileLoggedIn(true);
    } else {
      isProfileLoggedIn(false);
    }
  }

  ///Get Profile List
  Future<void> getProfileDetail({bool showLoader = true}) async {
    if (!isLoggedIn.value) return;
    isLoading(showLoader);
    await getProfileDetailsFuture(CoreServiceApis.getProfileDet()).then((value) {
      profileDetailsResp(value.data);
      currentSubscription(value.data.planDetails);

      if (currentSubscription.value.level > -1 && currentSubscription.value.planType.isNotEmpty && currentSubscription.value.planType.any((element) => element.slug == SubscriptionTitle.videoCast)) {
        isCastingSupported(currentSubscription.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.videoCast).limitationValue.getBoolInt());
      } else {
        isCastingSupported(false);
      }

      currentSubscription.value.activePlanInAppPurchaseIdentifier = isIOS ? currentSubscription.value.appleInAppPurchaseIdentifier : currentSubscription.value.googleInAppPurchaseIdentifier;
      setValue(SharedPreferenceConst.USER_SUBSCRIPTION_DATA, value.data.planDetails.toJson());
    }).whenComplete(() {
      isLoading(false);
    });
  }

  Future<void> onNextPage() async {
    if (!isLastPage.value) {
      page++;
      getRentedContentDetails();
    }
  }

  Future<void> onSwipeRefresh() async {
    page(1);
    getRentedContentDetails();
  }

  ///Get Person Wise Movie List
  Future<void> getRentedContentDetails({bool showLoader = true}) async {
    isLoading(showLoader);

    await rentedContentFuture(
      CoreServiceApis.getRentedContent(
        page: page.value,
        rentedContentList: rentedContentList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {
      cachedRentedContentList = cachedRentedContentList;
      log('value.length ==> ${value.length}');
    }).catchError((e) {
      log("getMovie List Err : $e");
    }).whenComplete(() => isLoading(false));
  }
}