// ignore_for_file: body_might_complete_normally_catch_error, deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:streamit_laravel/components/new_update_dialog.dart';
import 'package:streamit_laravel/utils/extension/get_x_extention.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';
import 'package:streamit_laravel/video_players/video_player_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../configs.dart';
import '../main.dart';
import 'app_common.dart';
import 'colors.dart';
import 'constants.dart';
import 'local_storage.dart';

bool isDynamic = true;

Widget get commonDivider => const Column(
      children: [
        Divider(height: 1, thickness: 0.6, color: borderColor),
      ],
    );

final fontFamilyWeight700 = GoogleFonts.interTight(fontWeight: FontWeight.w700).fontFamily;

void handleRate() async {
  if (isIOS) {
    if (getStringAsync(APP_APPSTORE_URL).isNotEmpty) launchUrlCustomURL(APP_APPSTORE_URL);
  } else {
    launchUrlCustomURL('$playStoreBaseURL${await getPackageName()}');
  }
}

void hideKeyBoardWithoutContext() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

void toggleThemeMode({required int themeId}) {
  if (themeId == THEME_MODE_SYSTEM) {
    Get.changeThemeMode(ThemeMode.system);
    isDarkMode(Get.isPlatformDarkMode);
  } else if (themeId == THEME_MODE_LIGHT) {
    Get.changeThemeMode(ThemeMode.light);
    isDarkMode(false);
  } else if (themeId == THEME_MODE_DARK) {
    Get.changeThemeMode(ThemeMode.dark);
    isDarkMode(true);
  }
  setValueToLocal(SettingsLocalConst.THEME_MODE, themeId);
  log('toggleDarkLightSwitch: $themeId');
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
      id: 1,
      name: locale.value.english,
      languageCode: 'en',
      fullLanguageCode: 'en-US',
      flag: Assets.flagsIcUs,
    ),
    LanguageDataModel(
      id: 2,
      name: locale.value.hindi,
      languageCode: 'hi',
      fullLanguageCode: 'hi-IN',
      flag: Assets.flagsIcIndia,
    ),
    LanguageDataModel(
      id: 3,
      name: locale.value.arabic,
      languageCode: 'ar',
      fullLanguageCode: 'ar-AR',
      flag: Assets.flagsIcAr,
    ),
    LanguageDataModel(
      id: 4,
      name: locale.value.french,
      languageCode: 'fr',
      fullLanguageCode: 'fr-FR',
      flag: Assets.flagsIcFr,
    ),
    LanguageDataModel(
      id: 4,
      name: locale.value.german,
      languageCode: 'de',
      fullLanguageCode: 'de-DE',
      flag: Assets.flagsIcDe,
    ),
  ];
}

Widget appCloseIconButton(BuildContext context, {required void Function() onPressed, double size = 12}) {
  return IconButton(
    iconSize: size,
    padding: EdgeInsets.zero,
    onPressed: onPressed,
    icon: Container(
      padding: EdgeInsets.all(size - 8),
      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: BorderRadius.circular(size - 4), border: Border.all()),
      child: Icon(
        Icons.close_rounded,
        size: size,
      ),
    ),
  );
}

Future<void> commonLaunchUrl(String address, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('${locale.value.invalidUrl}: $address');
  });
}

//region Common TextStyle

TextStyle get appButtonTextStyleGray => boldTextStyle(color: appColorSecondary, size: 14);

TextStyle get appButtonPrimaryColorText => boldTextStyle(color: appColorPrimary);

TextStyle get appButtonFontColorText => boldTextStyle(color: Colors.grey, size: 14);

TextStyle get appButtonTextStyleWhite => boldTextStyle(color: primaryTextColor, size: 14, weight: FontWeight.w600);

TextStyle commonW600SecondaryTextStyle({int? size, Color? color}) {
  return secondaryTextStyle(
    weight: FontWeight.w600,
    color: color ?? secondaryTextColor,
    size: size ?? 14,
  );
}

TextStyle commonW500SecondaryTextStyle({int? size, Color? color}) {
  return secondaryTextStyle(
    weight: FontWeight.w500,
    color: color ?? secondaryTextColor,
    size: size ?? 14,
  );
}

TextStyle commonSecondaryTextStyle({int? size, Color? color}) {
  return primaryTextStyle(
    weight: FontWeight.w800,
    color: color ?? darkGrayTextColor,
    size: size ?? 14,
  );
}

TextStyle commonPrimaryTextStyle({int? size, Color? color}) {
  return primaryTextStyle(
    weight: FontWeight.w800,
    color: color ?? white,
    size: size ?? 18,
  );
}

TextStyle commonW600PrimaryTextStyle({int? size, Color? color}) {
  return primaryTextStyle(
    weight: FontWeight.w600,
    color: color ?? primaryTextColor,
    size: size ?? 16,
  );
}

TextStyle commonW500PrimaryTextStyle({int? size, Color? color}) {
  return primaryTextStyle(
    weight: FontWeight.w500,
    color: color ?? primaryTextColor,
    size: size ?? 16,
  );
}

//endregion

//region Common Input Decoration
InputDecoration inputDecoration(
  BuildContext context, {
  Widget? prefixIcon,
  EdgeInsetsGeometry? contentPadding,
  BoxConstraints? prefixIconConstraints,
  BoxConstraints? suffixIconConstraints,
  Widget? suffixIcon,
  String? labelText,
  String? hintText,
  double? borderRadius,
  bool? filled,
  Color? fillColor,
  bool? alignLabelWithHint,
  InputBorder? enabledBorder,
  InputBorder? focusedErrorBorder,
  InputBorder? errorBorder,
  InputBorder? border,
  InputBorder? focusedBorder,
  InputBorder? disabledBorder,
}) {
  return InputDecoration(
    contentPadding: contentPadding,
    //labelText: labelText,
    counterText: "",
    hintText: hintText,
    hintStyle: secondaryTextStyle(),
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: alignLabelWithHint,
    prefixIcon: prefixIcon,
    prefixIconConstraints: prefixIconConstraints,
    suffixIcon: suffixIcon,
    suffixIconConstraints: suffixIconConstraints,
    enabledBorder: enabledBorder ??
        const UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 0.0),
        ),
    focusedErrorBorder: focusedErrorBorder ??
        const UnderlineInputBorder(
          borderSide: BorderSide(color: appColorPrimary, width: 0.0),
        ),
    errorBorder: errorBorder ??
        const UnderlineInputBorder(
          borderSide: BorderSide(color: appColorPrimary, width: 1.0),
        ),
    errorMaxLines: 2,
    border: border ??
        const UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 0.0),
        ),
    disabledBorder: disabledBorder ??
        const UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 0.0),
        ),
    errorStyle: primaryTextStyle(color: appColorPrimary, size: 12),
    focusedBorder: focusedBorder ??
        const UnderlineInputBorder(
          borderSide: BorderSide(color: white, width: 0.0),
        ),
    filled: filled,
    fillColor: fillColor,
  );
}

InputDecoration inputDecorationWithFillBorder(
  BuildContext context, {
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? labelText,
  String? hintText,
  double? borderRadius,
  bool? filled,
  Color? fillColor,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    hintText: hintText,
    hintStyle: secondaryTextStyle(size: 12),
    labelStyle: secondaryTextStyle(size: 12),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: canvasColor),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: canvasColor),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: appColorPrimary),
    ),
    errorMaxLines: 2,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: canvasColor),
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: canvasColor),
    ),
    errorStyle: primaryTextStyle(color: appColorPrimary, size: 12),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: canvasColor),
    ),
    filled: filled,
    fillColor: fillColor,
  );
}

//endregion

Widget backButton({Object? result, double size = 20, EdgeInsets? padding}) {
  return IconButton(
    padding: padding ?? EdgeInsets.zero,
    onPressed: () {
      Get.back(result: result);
    },
    icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white, size: size),
  );
}

/// Routes name to directly navigate the route by its name

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

String movieDurationTime(String time) {
  // Parse the input string
  List<String> parts = time.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = parts.length > 2 ? int.parse(parts[2]) : 0;

  // Create a Duration object
  Duration duration = Duration(hours: hours, minutes: minutes, seconds: seconds);

  // Extract hours, minutes, and seconds
  int h = duration.inHours;
  int m = duration.inMinutes.remainder(60);
  int s = duration.inSeconds.remainder(60);

  // Format the string
  String formattedTime = h == 0 ? '${m}m' : '${h}h ${m}m';
  if (s != 0) {
    formattedTime += ' ${s}s';
  }

  return formattedTime;
}

String movieDurationTimeWithFull(String time) {
  // Parse the input string
  List<String> parts = time.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = parts.length > 2 ? int.parse(parts[2]) : 0;

  // Create a Duration object
  Duration duration = Duration(hours: hours, minutes: minutes, seconds: seconds);

  // Extract hours, minutes, and seconds
  int h = duration.inHours;
  int m = duration.inMinutes.remainder(60);
  int s = duration.inSeconds.remainder(60);

  // Format the string
  String formattedTime = '';
  if (h > 0) formattedTime = '${h}h ';
  if (m > 0) {
    formattedTime += '${m}m ';
  } else if (s > 0) {
    formattedTime += '${s}s'; // Show seconds only if minutes are 0
  }

  return formattedTime;
}

// Pending Movie Percentage
(double pendingPercentage, String timeLeft) calculatePendingPercentage(String totalDuration, String pendingDuration) {
  Duration parseTime(String time) {
    if (time.isEmpty) {
      return Duration.zero; // Handle empty input
    }
    List<String> parts = time.split(':');
    int hours = 0, minutes = 0, seconds = 0;

    try {
      if (parts.length > 2) {
        hours = int.parse(parts[0]);
        minutes = int.parse(parts[1]);
        seconds = int.parse(parts[2]);
      } else {
        minutes = int.parse(parts[0]);
        seconds = int.parse(parts[1]);
      }
    } catch (e) {
      return Duration.zero; // Handle parsing error
    }

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  // Parse the time strings into Duration objects
  Duration movieTotalDuration = parseTime(totalDuration);
  Duration pendingTimeDuration = parseTime(pendingDuration);
  // Calculate the total seconds
  int totalSeconds = movieTotalDuration.inSeconds;
  int pendingSeconds = pendingTimeDuration.inSeconds;
  if (totalSeconds <= 0) {
    // Avoid division by zero or invalid total time
    return (0.0, "00:00:00 ");
  }

  // Calculate the percentage
  double pendingPercentage = (pendingSeconds / totalSeconds).clamp(0.0, 1.0);

  // Format the remaining time
  String formattedRemainingTime = movieDurationTimeWithFull(
    (movieTotalDuration - pendingTimeDuration).toString().split('.').first,
  );

  formattedRemainingTime = '$formattedRemainingTime${locale.value.left}';
  return (pendingPercentage, formattedRemainingTime);
}

class DashboardCategoryType {
  static const rateApp = 'rate-our-app';
  static const genres = 'genres';
  static const tvShow = 'popular_tvshow';
  static const horizontalList = 'horizontal_list';
  static const personality = 'personality';
  static const channels = 'top_channel';
  static const movie = 'popular_movie';
  static const video = 'popular_video';
  static const free = 'free_movie';
  static const language = 'popular_language';
  static const latestMovies = 'latest_movie';
  static const bannerAd = 'banner';
  static const advertisement = 'advertisement';
  static const top10 = 'top_10';
  static const personalised = 'personalised';
  static const trending = 'trending';
  static const payPerView = 'pay_per_view';
}

String timeFormatInHour(String dateString) {
  DateTime inputDate = DateTime.parse(dateString);
  DateTime now = DateTime.now();
  Duration difference = now.difference(inputDate);

  if (difference.inDays == 0) {
    if (difference.inHours > 0) {
      return '${difference.inHours} ${locale.value.hr}${difference.inHours > 1 ? locale.value.s : ''} ${locale.value.ago}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${locale.value.min}${difference.inMinutes > 1 ? locale.value.s : ''} ${locale.value.ago}';
    } else {
      return locale.value.justNow;
    }
  } else if (difference.inDays == 1) {
    return locale.value.yesterday;
  } else if (difference.inDays <= 2) {
    return '${difference.inDays} ${locale.value.daysAgo}';
  } else {
    return DateFormat('dd MMM, yyyy').format(inputDate);
  }
}

String dateFormat(String dateFormat) {
  if (dateFormat.isNotEmpty) {
    DateTime date = DateTime.parse(dateFormat.toString());
    DateFormat formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(date);
  } else {
    return "";
  }
}

//Show Mobile NO Format
String formatMobileNumber(String mobileNumber) {
  if (mobileNumber.length != 12) {
    return mobileNumber;
  }

  String countryCode = mobileNumber.substring(0, 2);
  String firstPart = mobileNumber.substring(2, 4);
  String lastPart = mobileNumber.substring(mobileNumber.length - 2);
  String maskedMiddlePart = "******";

  String formattedNumber = "+$countryCode $firstPart$maskedMiddlePart$lastPart";

  return formattedNumber;
}

DateTime calculateExpirationDate(DateTime startDate, String duration, int durationTime) {
  int durationTimes = durationTime;

  switch (duration.toLowerCase()) {
    case 'month':
      return DateTime(startDate.year, startDate.month + durationTimes, startDate.day);
    case 'year':
      return DateTime(startDate.year + durationTimes, startDate.month, startDate.day);
    case 'quarterly':
      return DateTime(startDate.year, startDate.month + (durationTimes * 3), startDate.day);
    case 'week':
      return startDate.add(Duration(days: durationTimes * 7));

    // Add more cases if needed
    default:
      return DateTime(startDate.year, startDate.month, startDate.day);
  }
}

Future<SnackbarController> errorSnackBar({required dynamic error, SnackPosition? position}) async {
  String message = '';
  if (error is String) {
    message = error;
  } else if (error is Map && error.containsKey('message')) {
    message = error['message'];
  } else if (error == null) {
    error = locale.value.somethingWentWrong;
  } else {
    message = error.toString();
  }

  if (!await isNetworkAvailable()) {
    message = locale.value.noInternetAvailable;
  }

  return Get.showSnackBar(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
    message: message,
    snackPosition: position ?? SnackPosition.TOP,
    colorText: primaryTextColor,
    backgroundColor: appColorPrimary,
  );
}

SnackbarController successSnackBar(String message, {SnackPosition? position}) {
  return Get.showSnackBar(
    message: message,
    snackPosition: position ?? SnackPosition.TOP,
    colorText: primaryTextColor,
    borderRadius: 10,
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
    backgroundColor: greenColor,
  );
}

String getNumberInString(int durationTime) {
  switch (durationTime) {
    case 1:
      return "one";
    case 2:
      return "two";
    case 3:
      return "three";
    case 4:
      return "four";
    case 5:
      return "five";
    case 6:
      return "six";
    case 7:
      return "seven";
    case 8:
      return "eight";
    case 9:
      return "nine";
    case 10:
      return "ten";
    case 11:
      return "eleven";
    case 12:
      return "twelve";
    case -1:
      return "one";
    // Add more cases if needed
    default:
      return "one";
  }
}

bool isMoviePaid({required int requiredPlanLevel}) {
  return (requiredPlanLevel != 0 && currentSubscription.value.level < requiredPlanLevel);
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitHours = twoDigits(duration.inHours);
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
}

//Player TYPES
class PlayerTypes {
  static const vimeo = 'vimeo';
  static const url = 'url';
  static const hls = 'hls';
  static const file = 'file';
  static const local = 'local';
  static const youtube = 'youtube';
  static const embedded = 'Embedded';
}

//Video Type
String getVideoType({required String type}) {
  String videoType = "";
  dynamic videoTypeMap = {
    "movie": VideoType.movie,
    "episode": VideoType.episode,
    "video": VideoType.video,
    "livetv": VideoType.liveTv,
    'tvshow': VideoType.tvshow,
  };
  videoType = videoTypeMap[type] ?? VideoType.episode;
  return videoType;
}

VideoPlayerModel getVideoPlayerResp(Map<String, dynamic> response) {
  return VideoPlayerModel.fromJson(response);
}

//PlayMovieOrVideo
Future<void> playMovie({
  bool isWatchVideo = false,
  required String continueWatchDuration,
  required String newURL,
  required String urlType,
  required String videoType,
  bool hasNextVideo = false,
  bool changeVideo = false,
  VideoPlayerModel? videoModel,
}) async {
  if (changeVideo) {
    LiveStream().emit(changeVideoInPodPlayer, [newURL, false, urlType, videoType, videoModel]);
  }

  if (isWatchVideo) {
    LiveStream().emit(mOnWatchVideo, [newURL, false, urlType, videoType, videoModel]);
  }
}

Widget commonLeadingWid({required String imgPath, IconData? icon, Color? color, double size = 20}) {
  return Image.asset(
    imgPath,
    width: size,
    height: size,
    color: color ?? appColorPrimary,
    fit: BoxFit.contain,
    errorBuilder: (context, error, stackTrace) => Icon(
      icon ?? Icons.now_wallpaper_outlined,
      size: size,
      color: color ?? appColorSecondary,
    ),
  );
}

String getVideoLink(String iframeString) {
  final regex = RegExp(r'src="(.*?)"');
  final match = regex.firstMatch(iframeString);
  return match?.group(1) ?? '';
}

void shareVideo({required String type, required int videoId}) {
  String shareURL = "";
  switch (type) {
    case VideoType.tvshow:
      {
        shareURL = '$DOMAIN_URL/tvshow-details/$videoId';
        break;
      }

    case VideoType.movie:
      {
        shareURL = '$DOMAIN_URL/movie-details/$videoId';
        break;
      }

    case VideoType.episode:
      {
        shareURL = '$DOMAIN_URL/episode-details/$videoId';
        break;
      }
    case VideoType.video:
      {
        shareURL = '$DOMAIN_URL/videos-details/$videoId';

        break;
      }
    case VideoType.liveTv:
      {
        shareURL = '$DOMAIN_URL/livetv-details/$videoId';

        break;
      }
    default:
      {
        shareURL = '';
        break;
      }
  }

  if (shareURL.isNotEmpty) {
    Share.shareUri(Uri.parse(shareURL.trim()));
  } else {
    toast("Sorry couldn't share this $type");
  }
}

void shareLiveVideoLink({required int liveTvId}) {
  String shareURL = "";
  shareURL = "$DOMAIN_URL/liveTv/$liveTvId";
  Share.shareUri(Uri.parse(shareURL.trim()));
}

String getReleaseYear(String date) {
  if (date.isNotEmpty) {
    String year = DateTime.parse(date).year.toString();
    return year;
  } else {
    return "";
  }
}

bool isAlreadyStartedWatching(String watchedTime) {
  return (watchedTime.isNotEmpty && watchedTime != '00:00:00');
}

Future<void> videoPlayerDispose({bool shouldVideoPause = false}) async {
  if (Get.isRegistered<VideoPlayersController>()) {
    /* try {
      Get.find<VideoPlayersController>().onClose();
    } catch (e) {
      debugPrint('Error disposing video player: $e');
    }*/
  }
}

String getIcons({required String title}) {
  Map<String, dynamic> iconMap = {
    SubscriptionTitle.videoCast: Assets.iconsIcDevices,
    SubscriptionTitle.ads: Assets.iconsIcNotepad,
    SubscriptionTitle.deviceLimit: Assets.iconsIcHighDefinition,
    SubscriptionTitle.downloadStatus: Assets.iconsIcDownload,
    SubscriptionTitle.supportedDeviceType: Assets.iconsIcDevices,
    SubscriptionTitle.profileLimit: Assets.iconsIcAccount,
  };
  return iconMap[title] ?? Assets.iconsIcPage;
}

int determinePerPage() {
  // Obtain the screen width in logical pixels
  final screenWidth = ui.window.physicalSize.width / ui.window.devicePixelRatio;
  if (screenWidth < 600) {
    // Mobile devices
    return 30;
  } else if (screenWidth < 1200) {
    // Tablet devices
    return 30;
  } else {
    // Other devices (e.g., desktops)
    return 30;
  }
}

String getSubscriptionPlanStatus(String status) {
  if (status == SubscriptionStatus.active) {
    return locale.value.active;
  } else if (status == SubscriptionStatus.inActive) {
    return locale.value.expired;
  } else if (status == SubscriptionStatus.cancel) {
    return locale.value.cancelled;
  } else if (status == SubscriptionStatus.deActive) {
    return 'Deactivated';
  } else {
    return '';
  }
}

void showNewUpdateDialog(BuildContext context, {required int currentAppVersionCode}) async {
  showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    barrierDismissible: currentAppVersionCode >= getPlatformMinimumVersion(),
    builder: (_) {
      return WillPopScope(
        onWillPop: () {
          return Future(() => currentAppVersionCode >= getPlatformMinimumVersion());
        },
        child: NewUpdateDialog(canClose: currentAppVersionCode >= getPlatformMinimumVersion()),
      );
    },
  );
}

int getPlatformMinimumVersion() {
  if (isIOS) {
    return appConfigs.value.iosMinimumForceUpdateCode;
  } else {
    return appConfigs.value.androidMinimumForceUpdateCode;
  }
}