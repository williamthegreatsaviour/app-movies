import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/live_tv/model/live_tv_dashboard_response.dart';

import '../../network/core_api.dart';

class LiveTVController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  Rx<Future<LiveChannelDashboardResponse>> getLiveDashboardFuture = Future(() => LiveChannelDashboardResponse(data: LiveChannelModel())).obs;
  Rx<LiveChannelDashboardResponse> liveDashboard = LiveChannelDashboardResponse(data: LiveChannelModel()).obs;

  Rx<PageController> sliderCont = PageController(initialPage: 0).obs;
  RxInt _currentPage = 0.obs;
  Rx<Timer> timer = Timer(const Duration(), () {}).obs;

  @override
  void onInit() {
    super.onInit();
    if (cachedLiveTvDashboard != null) {
      liveDashboard(cachedLiveTvDashboard);
    }
    getLiveDashboardDetail(startTimer: true);
  }

  void startAutoSlider() {
    if (liveDashboard.value.data.slider.length >= 2) {
      timer.value = Timer.periodic(const Duration(seconds: LIVE_AUTO_SLIDER_SECOND), (Timer timer) {
        if (_currentPage < liveDashboard.value.data.slider.length - 1) {
          _currentPage++;
        } else {
          _currentPage.value = 0;
        }
        if (sliderCont.value.hasClients) sliderCont.value.animateToPage(_currentPage.value, duration: const Duration(milliseconds: 950), curve: Curves.easeOutQuart);
      });
      sliderCont.value.addListener(() {
        _currentPage.value = sliderCont.value.page!.toInt();
      });
    }
  }

  ///Get Live Dashboard List
  Future<void> getLiveDashboardDetail({bool showLoader = true, bool startTimer = false}) async {
    if (showLoader) {
      isLoading(true);
    }
    await getLiveDashboardFuture(CoreServiceApis.getLiveDashboard()).then((value) {
      liveDashboard(value);
      if (startTimer) startAutoSlider();
    }).whenComplete(() => isLoading(false));
  }

  @override
  void onClose() {
    timer.value.cancel();
    super.onClose();
  }
}