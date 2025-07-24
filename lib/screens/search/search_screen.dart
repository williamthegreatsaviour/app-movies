import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/search/components/search_text_field.dart';
import 'package:streamit_laravel/screens/search/shimmer_search.dart';

import '../../components/app_scaffold.dart';
import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/horizontal_card_list_component.dart';
import 'components/search_component.dart';
import 'components/show_list/search_list_component.dart';
import 'search_controller.dart';

class SearchScreen extends StatelessWidget {
  final SearchScreenController searchCont;

  const SearchScreen({super.key, required this.searchCont});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      hasLeadingWidget: false,
      isLoading: searchCont.isLoading,
      hideAppBar: true,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchTextFieldComponent().paddingSymmetric(horizontal: 16, vertical: 16),
          Obx(() => const VoiceSearchLoadingWidget().visible(searchCont.isListening.isTrue).center()),
          Obx(
            () => SnapHelperWidget(
              future: searchCont.getSearchMovieFuture.value,
              loadingWidget: const ShimmerSearch(),
              errorBuilder: (error) {
                return NoDataWidget(
                  titleTextStyle: secondaryTextStyle(color: white),
                  subTitleTextStyle: primaryTextStyle(color: white),
                  title: error,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    searchCont.getSearchMovieDetail(showLoader: true);
                  },
                );
              },
              onSuccess: (res) {
                return Obx(
                  () => AnimatedScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    listAnimationType: commonListAnimationType,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HorizontalCardListComponent().visible(searchCont.searchMovieDetails.isEmpty),
                      10.height.visible(searchCont.searchCont.text.length > 2),
                      SearchComponent().visible(searchCont.searchCont.text.length > 2 && searchCont.isLoading.isFalse),
                      20.height.visible(searchCont.searchCont.text.length > 2),
                      if (searchCont.defaultPopularList.data.isNotEmpty) EmptySearchListComponent(sectionCategoryData: searchCont.defaultPopularList),
                    ],
                  ),
                );
              },
            ).expand(),
          ),
        ],
      ),
    );
  }
}
