import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/screens/search/model/search_list_model.dart';
import 'package:streamit_laravel/screens/search/search_controller.dart';

import '../../components/cached_image_widget.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/clear_all_component.dart';

class RecentSearchScreen extends StatelessWidget {
  final SearchScreenController searchController;

  const RecentSearchScreen({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      isLoading: searchController.isLoading,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      topBarBgColor: transparentColor,
      appBartitleText: locale.value.recentSearch,
      hasLeadingWidget: true,
      actions: [
        TextButton(
          onPressed: () {
            Get.bottomSheet(
              isDismissible: true,
              isScrollControlled: true,
              enableDrag: false,
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: ClearAllComponent(),
              ),
            ).then(
              (value) {
                Get.back();
              },
            );
          },
          child: Text(
            locale.value.clearAll,
            style: primaryTextStyle(color: appColorPrimary),
          ),
        ),
      ],
      body: AnimatedScrollView(
        refreshIndicatorColor: appColorPrimary,
        padding: const EdgeInsets.only(bottom: 120),
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        onSwipeRefresh: () async {
          return searchController.getSearchList();
        },
        children: [
          if (searchController.searchListData.isNotEmpty)
            ...List.generate(
              searchController.searchListData.length,
              (index) {
                SearchData searchItem = searchController.searchListData[index];
                return InkWell(
                  onTap: () {
                    searchController.searchCont.text = searchItem.searchQuery;
                    searchController.onSearch(searchVal: searchItem.searchQuery);
                    Get.back();
                  },
                  child: Row(
                    children: [
                      10.width,
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedImageWidget(
                          url: searchItem.fileUrl,
                          height: Get.height * 0.09,
                          width: Get.width * 0.19,
                          fit: BoxFit.cover,
                        ),
                      ),
                      20.width,
                      Marquee(
                        direction: Axis.horizontal,
                        textDirection: TextDirection.ltr,
                        animationDuration: const Duration(milliseconds: 5000),
                        pauseDuration: const Duration(milliseconds: 2000),
                        directionMarguee: DirectionMarguee.oneDirection,
                        child: Text(
                          searchItem.searchQuery,
                          style: primaryTextStyle(),
                        ),
                      ).expand()
                    ],
                  ).paddingSymmetric(vertical: 8, horizontal: 4),
                );
              },
            )
          else
            NoDataWidget(
              titleTextStyle: boldTextStyle(color: white),
              subTitleTextStyle: primaryTextStyle(color: white),
              title: locale.value.noRecentSearches,
              retryText: "",
              imageWidget: const EmptyStateWidget(),
            ).paddingSymmetric(horizontal: 16)
        ],
      ),
    );
  }
}