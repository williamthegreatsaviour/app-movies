import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/utils/app_common.dart';

import '../../main.dart';
import '../../utils/constants.dart';
import '../../video_players/model/video_model.dart';
import '../home/model/dashboard_res_model.dart';
import 'model/search_list_model.dart';
import 'model/search_response.dart';

class SearchScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;

  RxBool isLastPage = false.obs;
  TextEditingController searchCont = TextEditingController();
  FocusNode searchFocus = FocusNode();
  Rx<Future<SearchListResponse>> getSearchListApiFuture = Future(() => SearchListResponse()).obs;
  Rx<Future<SearchResponse>> getSearchMovieFuture = Future(() => SearchResponse()).obs;
  RxList<VideoPlayerModel> searchMovieDetails = RxList();
  stt.SpeechToText speechToText = stt.SpeechToText();
  RxBool isListening = false.obs;
  RxList<SearchData> searchListData = <SearchData>[].obs;

  CategoryListModel defaultPopularList = CategoryListModel();
  RxBool isTyping = false.obs;
  RxInt page = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getSearchList();
  }

  // Method to clear search text field
  void clearSearchField(BuildContext context) {
    log(searchMovieDetails);
    hideKeyboard(context);
    searchCont.clear();
    searchMovieDetails.clear();

    isTyping.value = false;
  }

//Get Search Movie Details
  Future<void> getSearchMovieDetail({bool showLoader = true}) async {
    searchMovieDetails.value = [];
    if (showLoader) {
      isLoading(true);
    }
    log(searchCont.text.trim());
    await getSearchMovieFuture(CoreServiceApis.getSearchDetails(search: searchCont.text)).then((value) {
      searchMovieDetails.clear();
      searchMovieDetails.addAll(value.movieList);
      searchMovieDetails.addAll(value.tvShowList);
      searchMovieDetails.addAll(value.videoList);
      searchMovieDetails.addAll(value.seasonList);
    }).whenComplete(() => isLoading(false));
  }

  //Get Search List
  Future<void> getSearchListHistory({bool showLoader = true}) async {
    isLoading(showLoader);
    await getSearchListApiFuture(CoreServiceApis.getSearchList()).then((value) {
      searchMovieDetails.clear();
      searchListData(value.data);
    }).whenComplete(() => isLoading(false));
  }

  void onSearch({required String searchVal}) {
    if (searchVal.length > 2) {
      getSearchMovieDetail();
    }
    if (searchVal.isNotEmpty) {
      isTyping.value = true;
    } else {
      isTyping.value = false;
    }
  }

  void startListening() async {
    bool available = await speechToText.initialize(
      onStatus: (status) {
        if (status == 'done') {
          isListening(false);
        }
      },
      onError: (error) => log('onError: $error'),
    );
    if (available) {
      isListening(true);
      speechToText.listen(onResult: (result) {
        searchCont.text = result.recognizedWords;

        if (searchCont.text.length > 2) {
          getSearchMovieDetail();
        } /*else if (searchCont.text.length == 3) {
          searchValue("");
        }*/
      });
    }
  }

  void stopListening() {
    speechToText.stop();
    isListening(false);
    searchCont.clear();
  }

  Future<void> saveSearch({required String searchQuery, required String type, required String searchID}) async {
    isLoading(true);
    CoreServiceApis.saveSearch(
      request: {
        "search_query": searchQuery,
        "profile_id": profileId.value,
        "search_id": searchID,
        "type": type,
      },
    ).then((value) async {
      getSearchList();
      searchCont.clear();
    }).catchError((e) {
      isLoading(false);
    }).whenComplete(() {
      isLoading(false);
    });
  }

  ///Get search List
  Future<void> getSearchList() async {
    if (getStringAsync(SharedPreferenceConst.POPULAR_MOVIE, defaultValue: '').isNotEmpty) {
      String defaultData = getStringAsync(SharedPreferenceConst.POPULAR_MOVIE);
      List<VideoPlayerModel> list = ((jsonDecode(defaultData)) as List).map((item) => VideoPlayerModel.fromJson(item)).toList();

      defaultPopularList = CategoryListModel(showViewAll: false, sectionType: locale.value.popularMovies, data: list);
    }

    if (isLoggedIn.isTrue) {
      await getSearchListHistory();
    }
  }

  /// Particular search Delete
  Future<void> particularSearchDelete({required int id}) async {
    try {
      isLoading(true);
      // Try the API call
      final result = await CoreServiceApis.particularSearchDelete(id, profileId.value);
      log(result.message);
    } catch (e) {
      log("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Clear All
  Future<void> clearAll() async {
    try {
      isLoading(true);
      // Try the API call
      final result = await CoreServiceApis.clearAll(profileId.value).then((value) async {
        await getSearchList();
      });
      log(result.message);
    } catch (e) {
      log("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    searchCont.clear();
    getSearchList();
    super.onClose();
  }
}