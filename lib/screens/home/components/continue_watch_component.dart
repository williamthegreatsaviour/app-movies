import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../network/core_api.dart';
import '../../../main.dart';
import '../../../utils/app_common.dart';
import '../../../utils/empty_error_state_widget.dart';
import '../../../video_players/model/video_model.dart';
import '../../continue_watching_list/components/continue_watching_item_component.dart';
import '../../continue_watching_list/components/remove_continue_watching_component.dart';
import '../../continue_watching_list/continue_watching_list_screen.dart';
import '../../profile/profile_controller.dart';
import '../home_controller.dart';

class ContinueWatchComponent extends StatelessWidget {
  final List<VideoPlayerModel> continueWatchList;

  const ContinueWatchComponent({super.key, required this.continueWatchList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        viewAllWidget(
          label: locale.value.continueWatching,
          showViewAll: continueWatchList.isNotEmpty,
          onButtonPressed: () {
            Get.to(() => ContinueWatchingListScreen());
          },
        ),
        continueWatchList.isNotEmpty
            ? HorizontalList(
                spacing: 12,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: continueWatchList.length,
                itemBuilder: (context, index) {

                  return Hero(
                    tag: index,
                    child: ContinueWatchingItemComponent(
                      continueWatchData: continueWatchList[index],
                      onRemoveTap: () {
                        handleRemoveFromContinueWatch(context, continueWatchList[index].id);
                      },
                    ),
                  );
                })
            : NoDataWidget(
                titleTextStyle: commonW600PrimaryTextStyle(),
                subTitleTextStyle: secondaryTextStyle(),
                title: locale.value.noItemsToContinueWatching,
                retryText: "",
                imageWidget: const EmptyStateWidget(),
              ).paddingSymmetric(horizontal: 16),
      ],
    );
  }

  Future<void> handleRemoveFromContinueWatch(BuildContext context, int id) async {
    Get.bottomSheet(
      RemoveContinueWatchingComponent(
        onRemoveTap: () {
          hideKeyboard(context);
          Get.back();
          final HomeController homeScreenCont = Get.find();

          homeScreenCont.isWatchListLoading(true);
          CoreServiceApis.removeContinueWatching(continueWatchingId: id).then((value) async {
            Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : Get.put(ProfileController());
            await homeScreenCont.getDashboardDetail(showLoader: true);
            ProfileController profileController = Get.put(ProfileController());
            await profileController.getProfileDetail();
            successSnackBar(locale.value.removedFromContinueWatch);
          }).catchError((e) {
            homeScreenCont.isWatchListLoading(false);
            errorSnackBar(error: e);
          }).whenComplete(() => homeScreenCont.isWatchListLoading(false));
        },
      ),
    );
  }
}