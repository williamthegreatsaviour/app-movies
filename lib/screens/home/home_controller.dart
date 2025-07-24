import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/ads_helper.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/screens/watch_list/watch_list_controller.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../configs.dart';
import '../../main.dart';
import '../../network/auth_apis.dart';
import '../../network/core_api.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';
import '../profile/profile_controller.dart';

class HomeController extends GetxController {
  bool forceSyncDashboardAPI;
  RxBool isLoading = true.obs;

  RxBool showCategoryShimmer = false.obs;
  RxBool isWatchListLoading = false.obs;
  RxBool isRefresh = false.obs;

  Rx<Future<DashboardDetailResponse>> getDashboardDetailFuture = Future(() => DashboardDetailResponse(data: DashboardModel())).obs;

  Rx<DashboardModel> dashboardDetail = DashboardModel().obs;
  Rx<PageController> sliderPageController = PageController(initialPage: 0).obs;

  final RxInt _currentPage = 0.obs;

  Rx<Timer> timer = Timer(const Duration(), () {}).obs;

  RxList<CategoryListModel> sectionList = RxList();

  //Ad Slider
  Rx<PageController> adPageController = PageController(initialPage: 0).obs;
  RxInt adCurrentPage = 0.obs;

  //BannerAd
  BannerAd? bannerAd;
  RxBool isAdShow = false.obs;

  HomeController({this.forceSyncDashboardAPI = false});

  @override
  void onInit() {
    if (cachedDashboardDetailResponse != null) {
      dashboardDetail(cachedDashboardDetailResponse!.data);
      createCategorySections(cachedDashboardDetailResponse!.data, true);
    }
    super.onInit();

    init(forceSync: forceSyncDashboardAPI);
  }

  void clearCache() {
    cachedDashboardDetailResponse = null;
  }

  Future<void> init({bool forceSync = false, bool showLoader = false, bool forceConfigSync = false}) async {
    getAppConfigurations(forceConfigSync);
    if (appConfigs.value.enableAds.getBoolInt()) bannerLoad();
    checkApiCallIsWithinTimeSpan(
      forceSync: forceSync,
      callback: () {
        getDashboardDetail(startTimer: true, showLoader: showLoader);
      },
      sharePreferencesKey: SharedPreferenceConst.DASHBOARD_DETAIL_LAST_CALL_TIME,
    );
  }

  Future<void> bannerLoad() async {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          log('$BannerAd loaded.');
          isAdShow(true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          log('$BannerAd failedToLoad: $error');
        },
        onAdOpened: (Ad ad) {
          log('$BannerAd onAdOpened.');
        },
        onAdClosed: (Ad ad) {
          log('$BannerAd onAdClosed.');
        },
      ),
    );
    await bannerAd?.load();
  }

  ///Get Dashboard List
  Future<void> getDashboardDetail({bool showLoader = false, bool startTimer = false}) async {
    isLoading(showLoader);
    isWatchListLoading(showLoader);

    await getDashboardDetailFuture(CoreServiceApis.getDashboard()).then((value) async {
      // Filter continueWatch list based on calculatePendingPercentage
      value.data.continueWatch.removeWhere((continueWatchData) {
        return calculatePendingPercentage(
          continueWatchData.totalWatchedTime.isEmpty || continueWatchData.totalWatchedTime == "00:00:00" ? "00:00:01" : continueWatchData.totalWatchedTime,
          continueWatchData.watchedTime.isEmpty || continueWatchData.watchedTime == "00:00:00" ? "00:00:01" : continueWatchData.watchedTime,
        ).$1 ==
            1;
      });

      if (value.data.slider.isNotEmpty) {
        value.data.slider.removeWhere((element) => element.data.status == 0);
        value.data.slider.removeWhere((element) => element.data.id == -1);
      }

      setValue(SharedPreferenceConst.DASHBOARD_DETAIL_LAST_CALL_TIME, DateTime.timestamp().millisecondsSinceEpoch);
      await createCategorySections(value.data, true);
      dashboardDetail(value.data);
      getOtherDashboardDetails(showLoader: true);
      isLoading(false);
      isWatchListLoading(false);

      if (startTimer) startAutoSlider();
    }).catchError((e) {
      isWatchListLoading(false);
      isLoading(false);
    });
  }

  Future<void> getOtherDashboardDetails({bool showLoader = false}) async {
    showCategoryShimmer(showLoader);
    await CoreServiceApis.getDashboardDetailOtherData().then((value) async {
      await createCategorySections(value.data, false);
      showCategoryShimmer(false);
      DashboardModel res = dashboardDetail.value;
      dashboardDetail(value.data);
      dashboardDetail.value.slider = res.slider;
      dashboardDetail.value.continueWatch = res.continueWatch;
      dashboardDetail.value.top10List = res.top10List;
      cachedDashboardDetailResponse = value;
      setValue(SharedPreferenceConst.CACHE_DASHBOARD, value.toJson());
    }).catchError((e) {
      showCategoryShimmer(false);
    });
  }

  Future<void> createCategorySections(DashboardModel dashboard, bool isFirstPage) async {
    isLoading(true);
    if (isFirstPage) sectionList.clear();
    if (!appConfigs.value.enableMovie) {
      dashboard.basedOnLastWatchMovieList.removeWhere((element) => element.type == VideoType.movie);
      dashboard.trendingInCountryMovieList.removeWhere((element) => element.type == VideoType.movie);
      dashboard.trendingMovieList.removeWhere((element) => element.type == VideoType.movie);
      dashboard.likeMovieList.removeWhere((element) => element.type == VideoType.movie);
      dashboard.viewedMovieList.removeWhere((element) => element.type == VideoType.movie);
      dashboard.payPerView.removeWhere((element) => element.type == VideoType.movie);
    }

    if (!appConfigs.value.enableTvShow) {
      dashboard.basedOnLastWatchMovieList.removeWhere((element) => element.type == VideoType.tvshow);
      dashboard.trendingInCountryMovieList.removeWhere((element) => element.type == VideoType.tvshow);
      dashboard.trendingMovieList.removeWhere((element) => element.type == VideoType.tvshow);
      dashboard.likeMovieList.removeWhere((element) => element.type == VideoType.tvshow);
      dashboard.viewedMovieList.removeWhere((element) => element.type == VideoType.tvshow);
      dashboard.payPerView.removeWhere((element) => element.type == VideoType.tvshow || element.type == VideoType.episode);
    }

    if (!appConfigs.value.enableVideo) {
      dashboard.basedOnLastWatchMovieList.removeWhere((element) => element.type == VideoType.video);
      dashboard.trendingInCountryMovieList.removeWhere((element) => element.type == VideoType.video);
      dashboard.trendingMovieList.removeWhere((element) => element.type == VideoType.video);
      dashboard.likeMovieList.removeWhere((element) => element.type == VideoType.video);
      dashboard.viewedMovieList.removeWhere((element) => element.type == VideoType.video);
      dashboard.payPerView.removeWhere((element) => element.type == VideoType.video);
    }

    if (sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.top10).isNegative && dashboard.top10List.isNotEmpty) {
      sectionList.add(
        CategoryListModel(
          name: locale.value.top10,
          sectionType: DashboardCategoryType.top10,
          data: dashboard.top10List,
        ),
      );
    }

    if (appConfigs.value.enableAds.getBoolInt() && sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.advertisement).isNegative) {
      sectionList.add(
        CategoryListModel(
          name: "",
          sectionType: DashboardCategoryType.advertisement,
          data: [],
        ),
      );
    }

    if (appConfigs.value.enableMovie && sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.latestMovies).isNegative && dashboard.latestList.isNotEmpty) {
      sectionList.add(
        CategoryListModel(
          name: locale.value.latestMovies,
          sectionType: DashboardCategoryType.latestMovies,
          data: dashboard.latestList,
        ),
      );
    }

    if (appConfigs.value.enableLiveTv && sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.channels).isNegative && dashboard.topChannelList.isNotEmpty) {
      sectionList.add(
        CategoryListModel(
          name: locale.value.topChannels,
          sectionType: DashboardCategoryType.channels,
          data: dashboard.topChannelList,
          showViewAll: dashboard.topChannelList.isNotEmpty,
        ),
      );
    }

    if (appConfigs.value.enableMovie &&
        sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.movie).isNegative &&
        dashboard.popularMovieList.isNotEmpty &&
        sectionList.indexWhere((element) => element.name == locale.value.popularMovies).isNegative) {
      setValue(SharedPreferenceConst.POPULAR_MOVIE, jsonEncode(dashboard.popularMovieList));
      sectionList.add(
        CategoryListModel(
          name: locale.value.popularMovies,
          sectionType: DashboardCategoryType.movie,
          data: dashboard.popularMovieList,
          showViewAll: dashboard.popularMovieList.isNotEmpty,
        ),
      );
    }

    if (sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.payPerView).isNegative && dashboard.payPerView.isNotEmpty && sectionList.indexWhere((element) => element.name == 'Pay Per View').isNegative) {
      sectionList.add(
        CategoryListModel(
          name: 'Pay Per View',
          sectionType: DashboardCategoryType.payPerView,
          data: dashboard.payPerView,
          showViewAll: dashboard.payPerView.isNotEmpty,
        ),
      );
    }
    if (appConfigs.value.enableTvShow && sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.tvShow).isNegative && dashboard.popularTvShowList.isNotEmpty) {
      sectionList.add(
        CategoryListModel(
          name: locale.value.popularTvShows,
          sectionType: DashboardCategoryType.tvShow,
          data: dashboard.popularTvShowList,
          showViewAll: dashboard.popularTvShowList.isNotEmpty,
        ),
      );
    }

    if (appConfigs.value.enableVideo && sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.video).isNegative && dashboard.popularVideoList.isNotEmpty) {
      sectionList.add(
        CategoryListModel(
          name: locale.value.popularVideos,
          sectionType: DashboardCategoryType.video,
          data: dashboard.popularVideoList,
          showViewAll: dashboard.popularVideoList.isNotEmpty,
        ),
      );
    }

    if (appConfigs.value.enableMovie &&
        sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.free).isNegative &&
        dashboard.freeMovieList.isNotEmpty &&
        sectionList.indexWhere((element) => element.name == locale.value.freeMovies).isNegative) {
      sectionList.add(
        CategoryListModel(
          name: locale.value.freeMovies,
          sectionType: DashboardCategoryType.movie,
          data: dashboard.freeMovieList,
          showViewAll: dashboard.freeMovieList.isNotEmpty,
        ),
      );
    }

    if (sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.genres).isNegative && dashboard.genreList.isNotEmpty && sectionList.indexWhere((element) => element.name == locale.value.genres).isNegative) {
      sectionList.add(
        CategoryListModel(
          name: locale.value.genres,
          sectionType: DashboardCategoryType.genres,
          data: dashboard.genreList,
          showViewAll: dashboard.genreList.isNotEmpty,
        ),
      );
    }

    if (sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.language).isNegative && dashboard.popularLanguageList.isNotEmpty) {
      sectionList.add(CategoryListModel(
        name: locale.value.popularLanguages,
        sectionType: DashboardCategoryType.language,
        data: dashboard.popularLanguageList,
        showViewAll: dashboard.popularLanguageList.isNotEmpty,
      ));
    }

    if (sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.personality).isNegative && dashboard.actorList.isNotEmpty && sectionList.indexWhere((element) => element.name == locale.value.actors).isNegative) {
      sectionList.add(CategoryListModel(
        name: locale.value.actors,
        sectionType: DashboardCategoryType.personality,
        data: dashboard.actorList,
        showViewAll: dashboard.actorList.isNotEmpty,
      ));
    }

    if (sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.trending).isNegative && dashboard.trendingMovieList.isNotEmpty) {
      sectionList.add(CategoryListModel(
        name: locale.value.trending,
        sectionType: DashboardCategoryType.trending,
        data: dashboard.trendingMovieList,
        showViewAll: true,
      ));
    }

    if (isLoggedIn.value) {
      if (dashboard.trendingInCountryMovieList.isNotEmpty && sectionList.indexWhere((element) => element.name == locale.value.trendingInYourCountry).isNegative) {
        sectionList.add(CategoryListModel(
          name: locale.value.trendingInYourCountry,
          sectionType: DashboardCategoryType.personalised,
          data: dashboard.trendingInCountryMovieList,
          showViewAll: false,
        ));
      }

      if (dashboard.favGenreList.isNotEmpty && sectionList.indexWhere((element) => element.name == locale.value.favoriteGenres).isNegative) {
        sectionList.add(CategoryListModel(
          name: locale.value.favoriteGenres,
          sectionType: DashboardCategoryType.genres,
          data: dashboard.favGenreList,
          showViewAll: false,
        ));
      }

      if (dashboard.basedOnLastWatchMovieList.isNotEmpty && sectionList.indexWhere((element) => element.name == locale.value.basedOnYourPreviousWatch).isNegative) {
        sectionList.add(
          CategoryListModel(
            name: locale.value.basedOnYourPreviousWatch,
            sectionType: DashboardCategoryType.personalised,
            data: dashboard.basedOnLastWatchMovieList,
            showViewAll: false,
          ),
        );
      }

      if (sectionList.indexWhere((element) => element.sectionType == DashboardCategoryType.personality).isNegative &&
          dashboard.favActorList.isNotEmpty &&
          sectionList.indexWhere((element) => element.name == locale.value.yourFavoritePersonalities).isNegative) {
        sectionList.add(CategoryListModel(
          name: locale.value.yourFavoritePersonalities,
          sectionType: DashboardCategoryType.personality,
          data: dashboard.favActorList,
          showViewAll: false,
        ));
      }

      if (dashboard.viewedMovieList.isNotEmpty && sectionList.indexWhere((element) => element.name == locale.value.mostViewed).isNegative) {
        sectionList.add(
          CategoryListModel(
            name: locale.value.mostViewed,
            sectionType: DashboardCategoryType.personalised,
            data: dashboard.viewedMovieList,
            showViewAll: false,
          ),
        );
      }

      if (dashboard.likeMovieList.isNotEmpty && sectionList.indexWhere((element) => element.name == locale.value.mostLiked).isNegative) {
        sectionList.add(
          CategoryListModel(
            name: locale.value.mostLiked,
            sectionType: DashboardCategoryType.personalised,
            data: dashboard.likeMovieList,
            showViewAll: false,
          ),
        );
      }
    }

    if (appConfigs.value.enableRateUs && sectionList.indexWhere((element) => element.sectionType != "rate-our-app").isNegative) {
      sectionList.add(
        CategoryListModel(
          name: "",
          sectionType: "rate-our-app",
          data: [],
        ),
      );
    }
    isLoading(false);
    // Add more categories if needed in the future
  }

  Future<void> getAppConfigurations(bool forceSync) async {
    if (forceSync) AuthServiceApis.getAppConfigurations(forceSync: forceSync);
  }

  Future<void> saveWatchLists(int index, {bool addToWatchList = true}) async {
    if (isWatchListLoading.isTrue) return;
    isWatchListLoading(true);

    dashboardDetail.refresh();
    if (addToWatchList) {
      CoreServiceApis.saveWatchList(
        request: {
          "entertainment_id": dashboardDetail.value.slider[index].data.id,
          if (profileId.value != 0) "profile_id": profileId.value,
        },
      ).then((value) async {
        await getDashboardDetail();
        successSnackBar(locale.value.addedToWatchList);
        updateWatchList();
      }).catchError((e) {
        errorSnackBar(error: e);
      }).whenComplete(() {
        isWatchListLoading(false);
      });
    } else {
      CoreServiceApis.deleteFromWatchlist(idList: [dashboardDetail.value.slider[index].data.id]).then((value) async {
        await getDashboardDetail();
        successSnackBar(locale.value.removedFromWatchList);
        updateWatchList();
      }).catchError((e) {
        errorSnackBar(error: e);
      }).whenComplete(() {
        isWatchListLoading(false);
      });
    }
  }

  void updateWatchList() {
    Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : Get.put(ProfileController());

    WatchListController controller = Get.isRegistered<WatchListController>() ? Get.find<WatchListController>() : Get.put(WatchListController());
    controller.getWatchList(showLoader: false);
  }

  Future<void> startAutoSlider() async {
    if (dashboardDetail.value.slider.length >= 2 && !isWatchListLoading.value) {
      timer.value = Timer.periodic(const Duration(milliseconds: DASHBOARD_AUTO_SLIDER_SECOND), (Timer timer) {
        if (_currentPage < dashboardDetail.value.slider.length - 1) {
          _currentPage.value++;
        } else {
          _currentPage.value = 0;
        }
        if (sliderPageController.value.hasClients) sliderPageController.value.animateToPage(_currentPage.value, duration: const Duration(milliseconds: 950), curve: Curves.easeOutQuart);
      });
      sliderPageController.value.addListener(() {
        _currentPage.value = sliderPageController.value.page!.toInt();
      });
    }
  }

  @override
  void onClose() {
    timer.value.cancel();
    bannerAd?.dispose();
    super.onClose();
  }
}