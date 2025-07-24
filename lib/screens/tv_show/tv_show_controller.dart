import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/tv_show/models/season_model.dart';
import 'package:streamit_laravel/screens/tv_show/models/tv_show_details_model.dart';
import 'package:streamit_laravel/screens/tv_show/models/tv_show_model.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';

import '../../network/core_api.dart';
import '../../main.dart';
import '../../utils/app_common.dart';
import '../../utils/cast/available_devices_for_cast.dart';
import '../../utils/cast/controller/fc_cast_controller.dart';
import '../../utils/cast/flutter_chrome_cast_widget.dart';
import '../../utils/constants.dart';
import '../../utils/video_download.dart';
import '../download_videos/components/download_component.dart';
import '../download_videos/download_video.dart';
import '../home/home_controller.dart';
import '../movie_details/components/add_review/add_review_controller.dart';
import '../profile/profile_controller.dart';
import '../review_list/model/review_model.dart';
import '../subscription/model/subscription_plan_model.dart';
import '../watch_list/watch_list_controller.dart';
import 'episode/models/episode_model.dart';

class TvShowController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingEpisode = false.obs;
  RxBool isLastPage = false.obs;
  RxBool isTrailer = true.obs;
  RxBool isViewAll = false.obs;
  RxBool isEpisodeScrolled = false.obs;
  RxBool isPlayingEpisode = false.obs;

  ScrollController scrollController = ScrollController();

  Rx<Future<TvShowModel>> getTvShowDetailsFuture = Future(() => TvShowModel(data: TvShowDetailsModel(yourReview: ReviewModel()))).obs;
  Rx<Future<RxList<EpisodeModel>>> getEpisodeListFuture = Future(() => RxList<EpisodeModel>()).obs;
  Rx<Future<EpisodeModel>> getEpisodeFuture = Future(() => EpisodeModel(plan: SubscriptionPlanModel())).obs;

  Rx<TvShowDetailsModel> tvShowDetail = TvShowDetailsModel(yourReview: ReviewModel()).obs;
  Rx<VideoPlayerModel> showData = VideoPlayerModel().obs;
  Rx<SeasonModel> selectSeason = SeasonModel().obs;

  Rx<EpisodeModel> selectedEpisode = EpisodeModel(plan: SubscriptionPlanModel()).obs;

  RxList<EpisodeModel> episodeList = RxList();

  RxInt currentEpisodeIndex = (-1).obs;
  RxInt page = 1.obs;
  RxInt currentSeason = 1.obs;
  RxInt downloadPercentage = 0.obs;

  RxBool isDownloaded = false.obs;
  RxBool showDownload = false.obs;

  RxBool isDownloading = false.obs;

  @override
  Future<void> onInit() async {
    if (Get.arguments is VideoPlayerModel) {
      showData(Get.arguments);
      if ((Get.arguments as VideoPlayerModel).type == VideoType.tvshow && (Get.arguments as VideoPlayerModel).episodeId == -1) {
        isTrailer(true);

        await getTvShowDetail(
          showLoader: false,
          tvShowId: (Get.arguments as VideoPlayerModel).entertainmentId != -1 ? (Get.arguments as VideoPlayerModel).entertainmentId : (Get.arguments as VideoPlayerModel).id,
        );
      } else {
        isTrailer(false);
        selectedEpisode(EpisodeModel.fromJson((Get.arguments as VideoPlayerModel).toJson()));
        isPlayingEpisode(true);
        await getEpisodeDetail(
          episodeId: (Get.arguments as VideoPlayerModel).episodeId,
          tvShowId: (Get.arguments as VideoPlayerModel).entertainmentId,
          isWatchVideo: false,
          changeVideo: false,
        );
      }
    }

    // Add LiveStream listeners
    setupLiveStreamTvListeners();
    super.onInit();
  }

  ///Get Show List
  Future<void> getTvShowDetail({bool showLoader = true, int tvShowId = -1}) async {
    isLoading(showLoader);

    await getTvShowDetailsFuture(
      CoreServiceApis.getTvShowDetails(
        showId: tvShowId != -1 ? tvShowId : tvShowDetail.value.id,
        userId: loginUserData.value.id,
      ),
    ).then((value) async {
      tvShowDetail(value.data);
      isSupportedDevice(value.data.isDeviceSupported);
      setValue(SharedPreferenceConst.IS_SUPPORTED_DEVICE, value.data.isDeviceSupported);
      if (value.data.tvShowLinks.isNotEmpty) {
        selectSeason(isPlayingEpisode.isTrue ? tvShowDetail.value.tvShowLinks.firstWhere((element) => element.seasonId == selectedEpisode.value.seasonId) : tvShowDetail.value.tvShowLinks.first);
        await getEpisodeList();
      }

      checkYourReview();
    }).whenComplete(() => isLoading(false));
  }

  void setupLiveStreamTvListeners() {
    // Listen for video player refresh events
    LiveStream().on(VIDEO_PLAYER_REFRESH_EVENT, (p0) {
      refreshTvPlayer();
    });
  }

  void refreshTvPlayer() {
    // Force a rebuild of the player
    isLoading(true);
    Future.delayed(const Duration(milliseconds: 100), () {
      isLoading(false);
    });
  }

  Future<void> getEpisodeDetail({
    bool showLoader = true,
    int episodeId = -1,
    int tvShowId = -1,
    bool changeVideo = false,
    bool isWatchVideo = false,
  }) async {
    isLoading(showLoader);
    await getEpisodeFuture(
      CoreServiceApis.episodeDetails(
        episodeId: episodeId > -1 ? episodeId : selectedEpisode.value.id,
        tvShowId: tvShowId > -1 ? tvShowId : tvShowDetail.value.id,
        seasonId: selectedEpisode.value.seasonId,
        userId: loginUserData.value.id,
      ),
    ).then((value) async {
      isSupportedDevice(value.isDeviceSupported);
      setValue(SharedPreferenceConst.IS_SUPPORTED_DEVICE, value.isDeviceSupported);
      selectedEpisode(value);

      if (value.availableSubTitle.isNotEmpty) {
        LiveStream().emit(REFRESH_SUBTITLE, value.availableSubTitle);
        selectedEpisode.value.availableSubTitle = value.availableSubTitle;
      }

      if (value.videoLinks!.isNotEmpty) {
        LiveStream().emit(onAddVideoQuality, value.videoLinks);
        selectedEpisode.value.videoLinks = value.videoLinks;
      }

      isTrailer(false);
      selectedEpisode.value.isPurchased = value.isPurchased;
      if (!isMoviePaid(requiredPlanLevel: value.requiredPlanLevel)) {
        playMovie(
          isWatchVideo: isWatchVideo,
          changeVideo: changeVideo,
          continueWatchDuration: value.watchedTime,
          newURL: value.videoUrlInput,
          urlType: value.videoUploadType,
          videoType: VideoType.episode,
          videoModel: showData.value,
        );
      }
      if (selectedEpisode.value.downloadQuality.isNotEmpty) {
        selectedEpisode.value.downloadQuality.removeWhere((element) =>
            element.type.toLowerCase() == URLType.youtube.toLowerCase() ||
            element.type.toLowerCase() == URLType.vimeo.toLowerCase() ||
            element.type.toLowerCase() == URLType.hsl.toLowerCase() ||
            element.type.toLowerCase() == URLType.file.toLowerCase());
      }

      checkIfAlreadyDownloaded();
      if (!changeVideo) {
        await getTvShowDetail(
          showLoader: false,
          tvShowId: selectedEpisode.value.entertainmentId,
        );
      }
    }).whenComplete(() => isLoading(false));
  }

  void onNextPage() {
    if (!isLastPage.value) {
      page.value++;
      getEpisodeList();
    }
  }

  Future<void> getEpisodeList({bool showLoader = true}) async {
    isLoadingEpisode(showLoader);
    await getEpisodeListFuture(
      CoreServiceApis.getEpisodesList(
        page: page.value,
        showId: tvShowDetail.value.id,
        seasonId: selectSeason.value.seasonId,
        episodeList: episodeList,
        lastPageCallBack: (p0) {
          isLastPage(p0);
          isViewAll(p0);
        },
      ),
    )
        .then((value) {
          if (selectedEpisode.value.id > 0) {
            currentEpisodeIndex(episodeList.indexWhere((element) => element.id == selectedEpisode.value.id));
          }
          log('value.length ==> ${value.length}');
        })
        .catchError((e) {})
        .whenComplete(() => isLoadingEpisode(false));
  }

  void checkYourReview() {
    AddReviewController movieDetCont = Get.put(AddReviewController());
    movieDetCont.isMovies(false);
    movieDetCont.movieId(tvShowDetail.value.id);
  }

  void editReview() {
    AddReviewController movieDetCont = Get.put(AddReviewController());
    movieDetCont.ratingVal(double.parse(tvShowDetail.value.yourReview.rating.toString()));
    movieDetCont.reviewCont.text = tvShowDetail.value.yourReview.review;
  }

  Future<void> deleteReview() async {
    isLoading(true);

    CoreServiceApis.deleteRating(
      request: {
        "id": tvShowDetail.value.yourReview.id,
      },
    ).then((value) async {
      await getTvShowDetail();
      final AddReviewController reviewControllerCont = Get.find<AddReviewController>();
      reviewControllerCont.onReviewCheck();
      successSnackBar(value.message.toString());
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() {
      Get.back();
      isLoading(false);
    });
  }

  Future<void> addLike() async {
    hideKeyBoardWithoutContext();
    isLoading(true);
    int isLike = tvShowDetail.value.isLiked ? 0 : 1;
    tvShowDetail.value.isLiked = isLike.getBoolInt() ? true : false;
    tvShowDetail.refresh();
    CoreServiceApis.likeMovie(
      request: {
        "entertainment_id": tvShowDetail.value.id,
        "is_like": isLike,
        if (profileId.value != 0) "profile_id": profileId.value,
      },
    ).then((value) async {
      await getTvShowDetail();
    }).catchError((e) {
      isLoading(false);
      tvShowDetail.value.isLiked = isLike.getBoolInt() ? true : false;
    });
  }

  Future<void> saveWatchList({bool addToWatchList = true}) async {
    if (isLoading.isTrue) return;
    isLoading(true);

    hideKeyBoardWithoutContext();
    if (addToWatchList) {
      tvShowDetail.value.isWatchList = true;
      CoreServiceApis.saveWatchList(
        request: {
          "entertainment_id": tvShowDetail.value.id,
          if (profileId.value != 0) "profile_id": profileId.value,
        },
      ).then((value) async {
        await getTvShowDetail();
        successSnackBar(locale.value.addedToWatchList);
        updateWatchList(tvShowDetail.value.id);
      }).catchError((e) {
        isLoading(false);
        tvShowDetail.value.isWatchList = false;
      });
    } else {
      tvShowDetail.value.isWatchList = false;
      CoreServiceApis.deleteFromWatchlist(idList: [tvShowDetail.value.id]).then((value) async {
        await getTvShowDetail();
        successSnackBar(locale.value.removedFromWatchList);
        updateWatchList(tvShowDetail.value.id);
      }).catchError((e) {
        isLoading(false);
        tvShowDetail.value.isWatchList = true;
        // errorSnackBar(e.toString());
      });
    }
  }

  void updateWatchList(int id) {
    Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : Get.put(ProfileController());
    Get.isRegistered<WatchListController>() ? Get.find<WatchListController>() : Get.put(WatchListController());
    HomeController homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

    if (homeController.dashboardDetail.value.slider.any((element) => element.id == id)) {
      homeController.getDashboardDetail();
    }
  }

  Future<void> storeView() async {
    hideKeyBoardWithoutContext();
    CoreServiceApis.storeViewDetails(
      request: {
        "entertainment_id": tvShowDetail.value.id,
        if (profileId.value != 0) "profile_id": profileId.value,
      },
    ).then((value) async {}).catchError((e) {
      log("Response Error ==> $e");
    }).whenComplete(() {
      log("Response Completed");
    });
  }

  Future<void> handleDownloads(BuildContext ctx) async {
    if (isDownloaded.value) {
      Get.off(() => DownloadVideosScreen())?.then(
        (value) {
          if (value ?? false) checkIfAlreadyDownloaded();
        },
      );
    } else {
      download();
    }
  }

  void download() {
    Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: false,
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: DownloadComponent(
          loaderOnOff: (p0) {
            isDownloading(p0);
          },
          downloadDet: selectedEpisode.value.downloadQuality,
          videoModel: showData.value,
          refreshCallback: () {
            checkIfAlreadyDownloaded();
          },
          downloadProgress: (p0) {
            downloadPercentage(p0);
          },
        ),
      ),
    );
  }

  Future<void> checkIfAlreadyDownloaded() async {
    showDownload(selectedEpisode.value.downloadStatus.getBoolInt() && selectedEpisode.value.downloadQuality.isNotEmpty);
    if (currentSubscription.value.level > -1 && currentSubscription.value.planType.isNotEmpty) {
      int index;
      index = currentSubscription.value.planType.indexWhere((element) => (element.limitationSlug == SubscriptionTitle.downloadStatus || element.slug == SubscriptionTitle.downloadStatus));
      if (index > -1) {
        showDownload(showDownload.value && currentSubscription.value.planType[index].limitationValue.getBoolInt());
      }
    }

    if (selectedEpisode.value.downloadQuality.length == 1 &&
        selectedEpisode.value.downloadQuality.first.quality == QualityConstants.defaultQuality &&
        (selectedEpisode.value.downloadType != URLType.url && selectedEpisode.value.downloadType != URLType.local)) {
      showDownload(false);
    }

    bool downloaded = await checkIfDownloaded(videoId: selectedEpisode.value.id);
    isDownloaded(downloaded);
  }

  Future openBottomSheetForFCCastAvailableDevices(BuildContext context) async {
    VideoPlayerModel videoModel = getVideoPlayerResp(showData.value.toJson());
    Get.bottomSheet(
      isDismissible: false,
      AvailableDevicesForCast(
        onTap: (p1) {
          Get.back();
          FCCast cast = Get.find();
          cast.setChromeCast(
            videoURL: isTrailer.isTrue && videoModel.watchedTime.isEmpty ? videoModel.trailerUrl : videoModel.videoUrlInput,
            device: p1,
            contentType: isTrailer.isTrue && videoModel.watchedTime.isEmpty ? videoModel.trailerUrlType.toLowerCase() : videoModel.videoUploadType.toLowerCase(),
            title: videoModel.name,
          );
          Get.to(() => FlutterChromeCastWidget());
        },
      ),
    );
  }

  void playNextEpisode(EpisodeModel episode) {
    if (episode.id != selectedEpisode.value.id) {
      onSubscriptionLoginCheck(
        planLevel: episode.requiredPlanLevel,
        videoAccess: episode.access,
        callBack: () {
          if (isLoggedIn.isTrue && (episode.requiredPlanLevel == 0 || currentSubscription.value.level >= selectedEpisode.value.requiredPlanLevel)) {
            isViewAll(false);
            selectedEpisode(episode);
            selectedEpisode.refresh();
            showData(VideoPlayerModel.fromJson(episode.toJson()));
            getEpisodeDetail(
              changeVideo: true,
            );
          }
        },
        planId: episode.planId,
      );
    }
  }

  void playPreviousEpisode() {
    int currentIndex = episodeList.indexWhere((e) => e.id == selectedEpisode.value.id);
    if (currentIndex > 0) {
      EpisodeModel prev = episodeList[currentIndex - 1];
      selectedEpisode(prev);
      selectedEpisode.refresh();
      showData(VideoPlayerModel.fromJson(prev.toJson()));
      getEpisodeDetail(changeVideo: true);
    }
  }

  @override
  void onClose() {
    videoPlayerDispose();
    LiveStream().dispose(VIDEO_PLAYER_REFRESH_EVENT);
    LiveStream().dispose(onAddVideoQuality);

    super.onClose();
  }
}