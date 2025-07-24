import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/auth/sign_in/sign_in_screen.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/model/profile_watching_model.dart';
import 'package:streamit_laravel/utils/price_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../components/cached_image_widget.dart';
import '../configs.dart';
import '../main.dart';
import '../screens/auth/model/about_page_res.dart';
import '../screens/auth/model/app_configuration_res.dart';
import '../screens/auth/model/login_response.dart';
import '../screens/setting/account_setting/model/account_setting_response.dart';
import '../screens/subscription/model/subscription_plan_model.dart';
import '../screens/subscription/subscription_screen.dart';
import 'colors.dart';
import 'common_base.dart';
import 'constants.dart';

///DO NOT CHANGE THE APP PACKAGE NAME
String appPackageName = 'com.iqonic.streamitlaravel';

Future<bool> get isIqonicProduct async => await getPackageName() == appPackageName;

RxString selectedLanguageCode = DEFAULT_LANGUAGE.obs;
RxBool isLoggedIn = false.obs;
RxBool is18Plus = false.obs;
Rx<UserData> loginUserData = UserData(planDetails: SubscriptionPlanModel()).obs;
RxList<AboutDataModel> appPageList = <AboutDataModel>[].obs;
RxBool isDarkMode = false.obs;
RxString tempOTP = "".obs;
Rx<DeviceInfoPlugin> deviceInfo = DeviceInfoPlugin().obs;
RxBool adsLoader = false.obs;
RxList<WatchingProfileModel> accountProfiles = RxList();
Rx<WatchingProfileModel> selectedAccountProfile = WatchingProfileModel().obs;
RxInt profileId = 0.obs;
RxBool isSupportedDevice = true.obs;
Rx<SubscriptionPlanModel> currentSubscription = SubscriptionPlanModel().obs;
RxBool isCastingSupported = false.obs;
RxBool isCastingAvailable = false.obs;
RxBool isInternetAvailable = true.obs;
RxBool isRTL = false.obs;
Rx<YourDevice> yourDevice = YourDevice().obs;
RxBool isPipModeOn = false.obs;
RxString profilePin = ''.obs;

ListAnimationType commonListAnimationType = ListAnimationType.None;

Rx<Currency> appCurrency = Currency().obs;
Rx<ConfigurationResponse> appConfigs = ConfigurationResponse(
  vendorAppUrl: VendorAppUrl(),
  razorPay: RazorPay(),
  stripePay: StripePay(),
  payStackPay: PaystackPay(),
  paypalPay: PaypalPay(),
  flutterWavePay: FlutterwavePay(),
  currency: Currency(),
).obs;

// Currency position common
bool get isCurrencyPositionLeft => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_LEFT;

bool get isCurrencyPositionRight => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_RIGHT;

bool get isCurrencyPositionLeftWithSpace => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_LEFT_WITH_SPACE;

bool get isCurrencyPositionRightWithSpace => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_RIGHT_WITH_SPACE;
//endregion

String get appNameTopic => APP_NAME.toLowerCase().replaceAll(' ', '_');

List top10Icons = [
  Assets.top10IconIcOne,
  Assets.top10IconIcTwo,
  Assets.top10IconIcThree,
  Assets.top10IconIcFour,
  Assets.top10IconIcFive,
  Assets.top10IconIcSix,
  Assets.top10IconIcSeven,
  Assets.top10IconIcEight,
  Assets.top10IconIcNine,
  Assets.top10IconIcTen,
];

String convertDate(String dateString) {
  if (dateString != "") {
    DateTime date = DateTime.parse(dateString);
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }
  return "";
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

ReadMoreText readMoreTextWidget(
  String data, {
  Color? colorClickableText,
  int trimLength = 250,
  int trimLines = 2,
  TrimMode trimMode = TrimMode.Line,
  TextAlign? textAlign,
  TextDirection? textDirection,
  double? textScaleFactor,
  String? semanticsLabel,
}) {
  return ReadMoreText(
    parseHtmlString(data),
    trimMode: trimMode,
    style: commonSecondaryTextStyle(color: descriptionTextColor),
    textAlign: textAlign,
    trimLength: trimLength,
    colorClickableText: colorClickableText,
    semanticsLabel: semanticsLabel,
    trimExpandedText: locale.value.readLess.prefixText(value: ' '),
    trimCollapsedText: locale.value.readMore,
    trimLines: trimLines,
    textScaleFactor: textScaleFactor,
  );
}

Widget viewAllWidget({
  required String label,
  Widget? iconButton,
  Color? labelColor,
  int? labelSize,
  void Function()? onButtonPressed,
  Icon? icon,
  IconData? iconData,
  double? iconSize,
  Color? iconColor,
  bool showViewAll = true,
  bool isSymmetricPaddingEnable = true,
}) {
  return Row(
    children: [
      Text(
        label,
        style: commonPrimaryTextStyle(size: labelSize ?? 18, color: labelColor ?? primaryTextColor),
      ).expand(),
      if (showViewAll)
        iconButton ??
            InkWell(
              onTap: onButtonPressed,
              splashColor: appColorPrimary.withValues(alpha: 0.5),
              highlightColor: Colors.transparent,
              child: Icon(
                iconData ?? Icons.chevron_right_rounded,
                size: iconSize ?? 20,
                color: iconColor ?? white,
              ),
            ),
    ],
  ).paddingSymmetric(horizontal: isSymmetricPaddingEnable ? 16 : 0, vertical: isSymmetricPaddingEnable ? 16 : 0);
}

String getEndPoint({required String endPoint, int? perPages, int? page, List<String>? params}) {
  String perPage = "?per_page=$perPages";
  String pages = "&page=$page";

  if (page != null && params.validate().isEmpty) {
    return "$endPoint$perPage$pages";
  } else if (page != null && params.validate().isNotEmpty) {
    return "$endPoint$perPage$pages&${params.validate().join('&')}";
  } else if (page == null && params != null && params.isNotEmpty) {
    return "$endPoint?${params.join('&')}";
  }
  return endPoint;
}

void doIfLogin({required VoidCallback onLoggedIn}) {
  if (isLoggedIn.value) {
    onLoggedIn.call();
  } else {
    LiveStream().emit(podPlayerPauseKey);
    Get.to(() => SignInScreen());
  }
}

void checkCastSupported({required VoidCallback onCastSupported}) {
  log('-----------------------Here--------------------------');
  log(isCastingSupported.value);
  if (isCastingSupported.value) {
    onCastSupported.call();
  } else {
    LiveStream().emit(podPlayerPauseKey);
    toast('${locale.value.castingNotSupported} ${locale.value.pleaseUpgradeToContinue}');
    Get.to(() => SubscriptionScreen(launchDashboard: false), preventDuplicates: false)?.then((v) {
      if (isCastingSupported.value) {
        onCastSupported.call();
      }
    });
  }
}

Widget watchNowButton({
  EdgeInsets? margin,
  required bool isTrailer,
  required int planId,
  required VoidCallback callBack,
  required int requiredPlanLevel,
  bool isPurchased = false,
}) {
  return AppButton(
    width: double.infinity,
    color: appColorPrimary,
    hoverColor: appColorPrimary,
    focusColor: appColorPrimary,
    textStyle: appButtonTextStyleWhite,
    margin: margin ?? EdgeInsets.symmetric(horizontal: 10),
    shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CachedImageWidget(
          url: Assets.iconsIcPlay,
          height: 10,
          width: 10,
        ),
        12.width,
        Marquee(
          child: Text(
            locale.value.watchNow,
            style: boldTextStyle(size: 14),
          ),
        ).flexible(),
      ],
    ),
    onTap: () async {
      onSubscriptionLoginCheck(
        callBack: callBack,
        planId: planId,
        videoAccess: planId <= 0 && requiredPlanLevel <= 0 ? MovieAccess.freeAccess : MovieAccess.paidAccess,
        planLevel: requiredPlanLevel,
      );
    },
  );
}

Widget rentAndPaidButton({
  EdgeInsets? margin,
  required bool isTrailer,
  required int planId,
  required VoidCallback callBack,
  required int requiredPlanLevel,
  required btnText,
  required discountPrice,
  required discount,
}) {
  return AppButton(
    width: double.infinity,
    color: rentedColor,
    hoverColor: appColorPrimary,
    focusColor: appColorPrimary,
    textStyle: appButtonTextStyleWhite,
    margin: margin ?? EdgeInsets.symmetric(horizontal: 10),
    shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CachedImageWidget(
          url: Assets.iconsIcRent,
          height: 14,
          width: 14,
          color: Colors.white,
        ),
        12.width,
        Text(
          'Rent For',
          style: boldTextStyle(size: 14),
        ),
        8.width,
        PriceWidget(price: btnText, discountedPrice: discountPrice, discount: discount, isDiscountedPrice: true, color: white, formatedPrice: btnText.toString()),
      ],
    ),
    onTap: () async {
      LiveStream().emit(podPlayerPauseKey);
      if (isLoggedIn.value) {
        callBack.call();
      } else {
        doIfLogin(onLoggedIn: callBack);
      }
    },
  );
}

void onSubscriptionLoginCheck({
  required VoidCallback callBack,
  int planId = 0,
  int planLevel = 0,
  required String videoAccess,
  bool isFromSubscribeCard = false,
  bool isPurchased = false,
}) {
  LiveStream().emit(podPlayerPauseKey);
  if (isLoggedIn.value) {
    if (planId == 0 && planLevel == 0 && isFromSubscribeCard) {
      //This is to launch subscription screen when not to navigate from origin
      Get.to(() => SubscriptionScreen(launchDashboard: false), preventDuplicates: false);
    } else {
      if (videoAccess == MovieAccess.freeAccess && isSupportedDevice.value) {
        callBack.call();
      } else {
        if (((videoAccess == MovieAccess.paidAccess || planLevel > 0) && currentSubscription.value.level < planLevel) || !isSupportedDevice.value) {
          if (!isSupportedDevice.value) {
            //Todo add
            toast('${locale.value.yourDeviceIsNot} ${locale.value.pleaseUpgradeToContinue}');
          }
          Get.to(() => SubscriptionScreen(launchDashboard: false), preventDuplicates: false, arguments: planLevel)?.then((v) {
            if (currentSubscription.value.level >= planLevel) {
              callBack.call();
            }
          });
        } else {
          callBack.call();
        }
      }
    }
  } else {
    doIfLogin(onLoggedIn: callBack);
  }
}

Future<void> handlePip({required dynamic controller, required BuildContext context}) async {
  if (isIOS) {
    if (controller.videoUrlInput.contains("youtube.com") || controller.videoUrlInput.contains("youtu.be")) {
      controller.webController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              log('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              log('Page started loading: $url');
            },
            onPageFinished: (String url) {
              controller.webController.runJavaScript('''
                        var style = document.createElement('style');
                        style.type = 'text/css';
                        style.innerHTML = `
                          .ytp-chrome-top,
                          .ytp-show-cards-title,
                          .ytp-title-link,
                          .ytp-chrome-top-buttons {
                            display: none !important;
                          }
                          .ytp-button.ytp-watch-later-button {
                            display: none !important;
                          }
                          .ytp-button.ytp-share-button {
                            display: none !important;
                          }
                          .ytp-watermark {
                            display: none !important;
                          }
                         `;
                        document.head.appendChild(style);
                        document.addEventListener('webkitpresentationmodechanged', function(event) {
                          if (event.target.webkitPresentationMode == 'picture-in-picture') {
                            console.log('Entered Picture-in-Picture');
                          } else {
                            console.log('Exited Picture-in-Picture');
                          }
                        });

                        var video = document.querySelector('video');
                        if (video) {
                          var requestPiP = document.createElement('button');
                          requestPiP.innerText = 'Enter Picture-in-Picture';
                          requestPiP.style.position = 'fixed';
                          requestPiP.style.bottom = '10px';
                          requestPiP.style.left = '10px';
                          requestPiP.style.zIndex = '1000';
                          requestPiP.onclick = function() {
                            if (document.pictureInPictureElement) {
                              document.exitPictureInPicture();
                            } else {
                              video.requestPictureInPicture();
                            }
                          };
                          document.body.appendChild(requestPiP);
                        } else {
                           console.error('No video element found');
                        }
                        ''');
            },
            onHttpError: (HttpResponseError error) {
              log('Error occurred on page: ${error.response?.statusCode}');
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://youtu.be/smTK_AeAPHs?si=UQAlhFHgP-j1YSjG')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(
          Uri.parse('https://www.youtube.com/embed/smTK_AeAPHs?si=fmjqoFkRZb9eYbEm&controls=0&rel=0&modestbranding=1&showinfo=0'),
        );

      WebViewWidget(controller: controller.webController).launch(context);
    } else {
      try {
        await MethodChannel("videoPlatform").invokeMethod('play', {
          "data": controller.videoUrlInput
          // "data": "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
          // "data": "https://storage.googleapis.com/exoplayer-test-media-0/BigBuckBunny_320x180.mp4"
        });
      } on PlatformException catch (e) {
        debugPrint("Fail: ${e.message}");
      }
    }
  } else {
    /// Android Picture In Picture Mode
    try {
      // Set up platform channel listener for PiP mode changes
      platform.setMethodCallHandler((call) async {
        if (call.method == 'onPipModeChanged') {
          bool newPipMode = call.arguments as bool;

          // Only update if the PiP state has actually changed to prevent unnecessary rebuilds
          if (isPipModeOn.value != newPipMode) {
            isPipModeOn.value = newPipMode;

            // If exiting PiP mode, trigger a rebuild of the video player
            if (!newPipMode) {
              // Add delay to ensure UI is ready
              await Future.delayed(const Duration(milliseconds: 300));
              // Emit event to refresh video player
              LiveStream().emit(VIDEO_PLAYER_REFRESH_EVENT);
            }
          }
        }
      });

      // Enter PiP mode through platform channel
      final bool isPipEnabled = await platform.invokeMethod('showNativeView');
      isPipModeOn.value = isPipEnabled;
    } catch (e) {
      debugPrint("PiP Error: $e");
    }
  }
}

List<(String, IconData, Color)> getSupportedDeviceText({bool isMobileSupported = false, bool isDesktopSupported = false, bool isTabletSupported = false}) {
  List<(String, IconData, Color)> supportedDeviceText = [];

  supportedDeviceText.add(
    (
      '${locale.value.mobile}${isMobileSupported ? locale.value.supported : locale.value.notSupported}',
      isMobileSupported ? Icons.check_circle_outline_rounded : Icons.clear,
      isMobileSupported ? discountColor : redColor,
    ),
  );
  supportedDeviceText.add((
    '${locale.value.laptop}${isDesktopSupported ? locale.value.supported : locale.value.notSupported}',
    isDesktopSupported ? Icons.check_circle_outline_rounded : Icons.clear,
    isDesktopSupported ? discountColor : redColor,
  ));
  supportedDeviceText.add(
    (
      '${locale.value.tablet.suffixText(value: ' ')}${isTabletSupported ? locale.value.supported : locale.value.notSupported}',
      isTabletSupported ? Icons.check_circle_outline_rounded : Icons.clear,
      isTabletSupported ? discountColor : redColor,
    ),
  );

  return supportedDeviceText;
}

(String, String) getDownloadQuality(PlanLimit? planLimit) {
  String notSupportedText = '';
  String supportedText = '';
  if (planLimit != null) {
    if (planLimit.four80Pixel.getBoolInt()) {
      supportedText += '480P';
    } else {
      notSupportedText += '480P';
    }
    if (planLimit.seven20p.getBoolInt()) {
      supportedText += '720P';
    } else {
      notSupportedText += '720P';
    }
    if (planLimit.one080p.getBoolInt()) {
      supportedText += '1080P';
    } else {
      notSupportedText += '1080P';
    }
    if (planLimit.oneFourFour0Pixel.getBoolInt()) {
      supportedText += '1440P';
    } else {
      notSupportedText += '1440P';
    }
    if (planLimit.twoKPixel.getBoolInt()) {
      supportedText += '2K';
    } else {
      notSupportedText += '2K';
    }
    if (planLimit.fourKPixel.getBoolInt()) {
      supportedText += '4K';
    } else {
      notSupportedText += '4K';
    }
    if (planLimit.eightKPixel.getBoolInt()) {
      supportedText += '8k';
    } else {
      notSupportedText += '8k';
    }
  }

  RegExp regex = RegExp(r"(?<=P|K)");
  List<String> notSupportedParts = [];
  List<String> supportedParts = [];
  if (notSupportedText.isNotEmpty) {
    notSupportedParts = notSupportedText.split(regex);
  }
  if (supportedText.isNotEmpty) supportedParts = supportedText.split(regex);

  return (supportedParts.join('/'), notSupportedParts.join('/'));
}

String getPageIcon(String slug) {
  switch (slug) {
    case AppPages.privacyPolicy:
      {
        return Assets.iconsIcPrivacy;
      }
    case AppPages.termsAndCondition:
      {
        return Assets.iconsIcTc;
      }
    case AppPages.helpAndSupport:
      {
        return Assets.iconsIcFaq;
      }
    case AppPages.refundAndCancellation:
      {
        return Assets.iconsIcRefund;
      }
    case AppPages.dataDeletion:
      {
        return Assets.iconsIcDataDelete;
      }
    case AppPages.aboutUs:
      {
        return Assets.iconsIcAboutUs;
      }
    default:
      return Assets.iconsIcPage;
  }
}

Future<void> launchUrlCustomURL(String? url) async {
  if (url.validate().isNotEmpty) {
    await custom_tabs.launchUrl(
      Uri.parse(url.validate()),
      customTabsOptions: custom_tabs.CustomTabsOptions(
        colorSchemes: custom_tabs.CustomTabsColorSchemes.defaults(toolbarColor: appColorPrimary),
        animations: custom_tabs.CustomTabsSystemAnimations.slideIn(),
        urlBarHidingEnabled: true,
        shareState: custom_tabs.CustomTabsShareState.on,
        browser: custom_tabs.CustomTabsBrowserConfiguration(
          fallbackCustomTabs: [
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
          headers: {'key': 'value'},
        ),
      ),
      safariVCOptions: custom_tabs.SafariViewControllerOptions(
        barCollapsingEnabled: true,
        dismissButtonStyle: custom_tabs.SafariViewControllerDismissButtonStyle.close,
        entersReaderIfAvailable: false,
        preferredControlTintColor: appScreenBackgroundDark,
        preferredBarTintColor: appColorPrimary,
      ),
    );
  }
}

Future<void> checkApiCallIsWithinTimeSpan({bool forceSync = false, required VoidCallback callback, required String sharePreferencesKey, Duration? duration}) async {
  DateTime currentTimeStamp = DateTime.timestamp();
  DateTime lastSyncedTimeStamp = DateTime.fromMillisecondsSinceEpoch(getIntAsync(sharePreferencesKey, defaultValue: 0));
  DateTime fiveMinutesLater = lastSyncedTimeStamp.add(duration ?? const Duration(minutes: 5));

  if (forceSync || currentTimeStamp.isAfter(fiveMinutesLater)) {
    callback.call();
  } else {
    log('$sharePreferencesKey was synced recently');
  }
}

DashboardController getDashboardController() {
  return Get.put(DashboardController());
}

bool isComingSoon(String releaseDate) {
  DateTime now = DateTime.now();
  DateTime releaseDateParsed = DateFormat(DateFormatConst.yyyy_MM_dd).parse(releaseDate);
  return releaseDateParsed.isAfter(now);
}