import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/search/model/search_list_model.dart';
import 'package:streamit_laravel/utils/app_common.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../recent_search_screen.dart';
import '../search_controller.dart';

class HorizontalCardListComponent extends StatelessWidget {
  final SearchScreenController searchController = Get.put(SearchScreenController());

  HorizontalCardListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => searchController.searchListData.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                viewAllWidget(
                  label: locale.value.searchHistory.capitalizeEachWord(),
                  showViewAll: searchController.searchListData.length > 3,
                  iconButton: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: appColorPrimary.withValues(alpha: 0.4),
                    radius: defaultRadius,
                    onTap: () {
                      Get.to(() => RecentSearchScreen(searchController: searchController));
                    },
                    child: Text(
                      locale.value.viewAll,
                      style: commonSecondaryTextStyle(color: appColorPrimary),
                    ),
                  ),
                ),
                HorizontalList(
                  itemCount: searchController.searchListData.take(5).length,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  wrapAlignment: WrapAlignment.start,
                  itemBuilder: (context, index) {
                    SearchData searchData = searchController.searchListData[index];
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            searchController.searchCont.text = searchData.searchQuery;
                            searchController.onSearch(searchVal: searchData.searchQuery);
                          },
                          child: Container(
                            width: Get.width / 2 - 32,
                            height: Get.height * 0.08,
                            decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(5)),
                            child: Row(
                              children: [
                                CachedImageWidget(
                                  url: searchData.fileUrl,
                                  width: Get.width * 0.13,
                                  fit: BoxFit.cover,
                                ).cornerRadiusWithClipRRect(3).paddingSymmetric(horizontal: 4, vertical: 4),
                                6.width,
                                Marquee(
                                  direction: Axis.horizontal,
                                  textDirection: TextDirection.ltr,
                                  animationDuration: const Duration(milliseconds: 5000),
                                  pauseDuration: const Duration(milliseconds: 2000),
                                  directionMarguee: DirectionMarguee.oneDirection,
                                  child: Text(
                                    searchData.searchQuery,
                                    style: primaryTextStyle(),
                                  ),
                                ).expand(),
                                6.width,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await searchController.particularSearchDelete(id: searchData.id);
                              await searchController.getSearchList();
                            },
                            child: const CachedImageWidget(
                              url: Assets.iconsIcClear,
                              height: 13,
                              width: 13,
                              color: appColorPrimary,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            )
          : const Offstage(),
    );
  }
}
