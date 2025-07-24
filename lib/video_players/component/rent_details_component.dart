import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_details/model/live_tv_details_response.dart';
import 'package:streamit_laravel/screens/subscription/components/subscription_price_component.dart';
import 'package:streamit_laravel/screens/subscription/subscription_controller.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/video_players/component/rent_detail_bottomsheet_controller.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';
import 'package:streamit_laravel/video_players/video_description_widget.dart';

import '../../main.dart';
import '../../screens/auth/model/about_page_res.dart';
import '../../utils/constants.dart';
import '../video_player_controller.dart';

class RentalDetailsComponent extends StatelessWidget {
  final bool isLive;
  final LiveShowModel? liveShowModel;
  final VideoPlayerModel videoModel;
  final VoidCallback? onWatchNow;
  final bool isTrailer;
  final bool isComingSoonScreen;
  final bool showWatchNow;
  final bool hasNextEpisode;

  RentalDetailsComponent({
    super.key,
    required this.isLive,
    required this.liveShowModel,
    required this.videoModel,
    this.onWatchNow,
    this.hasNextEpisode = false,
    required this.isTrailer,
    required this.isComingSoonScreen,
    required this.showWatchNow,
  });

  final RentDetailsController rentDetailsController = Get.put(RentDetailsController());

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return AnimatedScrollView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(locale.value.info, style: boldTextStyle(size: 18)),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    rentDetailsController.isChecked.value = false;
                  },
                  child: Icon(Icons.clear),
                ),
              ],
            ),
            Divider(
              color: dividerColor,
            ),
            VideoDescriptionWidget(
              videoDescription: isLive ? VideoPlayerModel.fromJson(liveShowModel!.toJson()) : videoModel,
              onWatchNow: () async {},
              isTrailer: isTrailer,
            ),
            Container(
              decoration: boxDecorationDefault(
                borderRadius: radius(defaultRadius),
                color: canvasColor,
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: 8,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locale.value.validity,
                        style: boldTextStyle(),
                      ),
                      Text(
                        '${videoModel.availableFor} ${locale.value.days}',
                        style: boldTextStyle(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        locale.value.watchTime,
                        style: boldTextStyle(),
                      ),
                      Text(
                        ' ${videoModel.accessDuration} ${locale.value.days}',
                        style: boldTextStyle(),
                      ),
                    ],
                  ),
                  Divider(
                    color: borderColor,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBulletRow(locale.value.rentedesc(videoModel.availableFor, videoModel.accessDuration.toString())),
                      _buildBulletRow(locale.value.youCanWatchThis(videoModel.accessDuration)),
                      _buildBulletRow(locale.value.thisIsANonRefundable),
                      _buildBulletRow(locale.value.thisContentIsOnly),
                      _buildBulletRow(locale.value.youCanPlayYour),
                    ],
                  ),
                  if (videoModel.isPurchased == false)
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: rentDetailsController.isChecked.value,
                            onChanged: (bool? newValue) {
                              rentDetailsController.isChecked.value = newValue ?? false;
                            },
                            checkColor: Colors.white,
                            activeColor: appColorPrimary,
                            side: BorderSide(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: secondaryTextStyle(),
                              children: [
                                TextSpan(text: locale.value.byRentingYouAgreeToOur, style: secondaryTextStyle(size: 12)),
                                TextSpan(
                                  text: locale.value.termsOfUse,
                                  style: boldTextStyle(
                                    size: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      final AboutDataModel aboutDataModel = appPageList.firstWhere((element) => element.slug == AppPages.termsAndCondition);
                                      if (aboutDataModel.url.validate().isNotEmpty) launchUrlCustomURL(aboutDataModel.url.validate());
                                      log(aboutDataModel.url.validate());
                                    },
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (videoModel.isPurchased == false)
                    rentAndPaidButton(
                      isTrailer: isTrailer,
                      planId: videoModel.planId,
                      btnText: videoModel.price,
                      discount: videoModel.discount,
                      discountPrice: videoModel.discountedPrice,
                      callBack: () {
                        if (!rentDetailsController.isChecked.value) {
                          toast(locale.value.pleaseAgreeToThe);
                          return;
                        }
                        Get.back();
                        Get.bottomSheet(
                          PriceComponent(
                            launchDashboard: false,
                            subscriptionCont: SubscriptionController(),
                            isRent: true, // NEW
                            rentVideo: videoModel, // NEW
                          ),
                        );
                      },
                      requiredPlanLevel: videoModel.requiredPlanLevel,
                    ),
                  if (videoModel.isPurchased == true)
                    watchNowButton(
                      isTrailer: isTrailer,
                      planId: videoModel.planId,
                      requiredPlanLevel: videoModel.requiredPlanLevel,
                      callBack: () {
                        if (videoModel.movieAccess == MovieAccess.payPerView && videoModel.isPurchased == true && videoModel.purchaseType == PurchaseType.rental) {
                          final VideoPlayersController videoPlayersController = Get.find<VideoPlayersController>();
                          videoPlayersController.startDate();
                        }
                        onWatchNow?.call();
                      },
                    ).paddingSymmetric(vertical: 8),
                ],
              ),
            ),
            16.height
          ],
        );
      },
    );
  }
}

Widget _buildBulletRow(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: secondaryTextStyle()),
        Expanded(child: Text(text, style: secondaryTextStyle())),
      ],
    ),
  );
}