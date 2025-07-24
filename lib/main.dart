import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/locale/language_en.dart';
import 'package:streamit_laravel/screens/auth/model/app_configuration_res.dart';
import 'package:streamit_laravel/screens/auth/model/login_response.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/screens/live_tv/model/live_tv_dashboard_response.dart';
import 'package:streamit_laravel/screens/person/model/person_model.dart';
import 'package:streamit_laravel/services/in_app_purhcase_service.dart';
import 'package:streamit_laravel/utils/local_storage.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';
import 'package:y_player/y_player.dart';

import 'app_theme.dart';
import 'configs.dart';
import 'firebase_options.dart';
import 'locale/app_localizations.dart';
import 'locale/languages.dart';
import 'network/auth_apis.dart';
import 'screens/profile/model/profile_detail_resp.dart';
import 'screens/splash_screen.dart';
import 'utils/app_common.dart';
import 'utils/colors.dart';
import 'utils/common_base.dart';
import 'utils/constants.dart';
import 'utils/local_storage.dart' as local;
import 'utils/push_notification_service.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('${FirebaseMsgConst.notificationDataKey} : ${message.data}');
  log('${FirebaseMsgConst.notificationKey} : ${message.notification}');
  log('${FirebaseMsgConst.notificationTitleKey} : ${message.notification!.title}');
  log('${FirebaseMsgConst.notificationBodyKey} : ${message.notification!.body}');
}

Rx<BaseLanguage> locale = LanguageEn().obs;

DashboardDetailResponse? cachedDashboardDetailResponse;

LiveChannelDashboardResponse? cachedLiveTvDashboard;

ProfileDetailResponse? cachedProfileDetails;

InAppPurchaseService inAppPurchaseService = InAppPurchaseService();

// RxLists for cached lists
RxList<VideoPlayerModel> cachedMovieList = RxList<VideoPlayerModel>();
RxList<VideoPlayerModel> cachedTvShowList = RxList<VideoPlayerModel>();
RxList<VideoPlayerModel> cachedVideoList = RxList<VideoPlayerModel>();
RxList<ComingSoonModel> cachedComingSoonList = RxList<ComingSoonModel>();
RxList<VideoPlayerModel> cachedContinueWatchList = RxList<VideoPlayerModel>();
RxList<VideoPlayerModel> cachedWatchList = RxList<VideoPlayerModel>();
RxList<VideoPlayerModel> cachedRentedContentList = RxList<VideoPlayerModel>();
RxList<ChannelModel> cachedChannelList = RxList();
RxList<PersonModel> cachedPersonList = RxList();
RxBool isChild = true.obs;

const platform = MethodChannel('flutter.iqonic.streamitlaravel.com.channel');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  YPlayerInitializer.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
    PushNotificationService().initFirebaseMessaging();
    if (kReleaseMode) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    }
  }).catchError(onError);
  await GetStorage.init();
  //
  fontFamilyPrimaryGlobal = GoogleFonts.roboto(fontWeight: FontWeight.normal, fontSize: 16).fontFamily;
  textPrimarySizeGlobal = 16;
  fontFamilySecondaryGlobal = GoogleFonts.roboto(fontWeight: FontWeight.normal, color: secondaryTextColor, fontSize: 14).fontFamily;
  textSecondarySizeGlobal = 14;
  fontFamilyBoldGlobal = GoogleFonts.roboto(fontWeight: FontWeight.bold, color: primaryTextColor, fontSize: 16).fontFamily;
  textPrimaryColorGlobal = primaryTextColor;
  textSecondaryColorGlobal = secondaryTextColor;
  //
  defaultBlurRadius = 0;
  defaultRadius = 12;
  defaultSpreadRadius = 0;
  appButtonBackgroundColorGlobal = appColorPrimary;
  defaultAppButtonRadius = defaultRadius;
  defaultAppButtonElevation = 0;
  defaultAppButtonTextColorGlobal = primaryTextColor;
  passwordLengthGlobal = 8;

  selectedLanguageCode(local.getValueFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);

  await initialize(aLocaleLanguageList: languageList(), defaultLanguage: selectedLanguageCode.value);

  BaseLanguage temp = await const AppLocalizations().load(Locale(selectedLanguageCode.value));
  locale = temp.obs;
  locale.value = await const AppLocalizations().load(Locale(selectedLanguageCode.value));

  if (getStringAsync(SharedPreferenceConst.CONFIGURATION_RESPONSE).isNotEmpty) {
    ConfigurationResponse configData = ConfigurationResponse.fromJson(jsonDecode(getStringAsync(SharedPreferenceConst.CONFIGURATION_RESPONSE)));
    appConfigs(configData);
  }

  try {
    final getThemeFromLocal = local.getValueFromLocal(SettingsLocalConst.THEME_MODE);
    if (getThemeFromLocal is int) {
      toggleThemeMode(themeId: getThemeFromLocal);
    } else {
      toggleThemeMode(themeId: THEME_MODE_LIGHT);
    }
  } catch (e) {
    log('getThemeFromLocal from cache E: $e');
  }

  isLoggedIn(getBoolValueAsync(SharedPreferenceConst.IS_LOGGED_IN, defaultValue: false) || getStringAsync(SharedPreferenceConst.USER_DATA).isNotEmpty);

  if (isLoggedIn.value) {
    final userData = getStringAsync(SharedPreferenceConst.USER_DATA);

    if (getStringAsync(SharedPreferenceConst.USER_DATA).isNotEmpty) {
      loginUserData(UserData.fromJson(jsonDecode(userData)));
    } else {
      isLoggedIn(false);
      AuthServiceApis.clearData();
    }
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: appScreenBackgroundDark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: appScreenBackgroundDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  HttpOverrides.global = MyHttpOverrides();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: APP_NAME,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.noTransition,
      supportedLocales: LanguageDataModel.languageLocales(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(0.8)),
          child: child!,
        );
      },
      localizationsDelegates: const [
        AppLocalizations(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) => Locale(selectedLanguageCode.value),
      fallbackLocale: const Locale(DEFAULT_LANGUAGE),
      locale: Locale(selectedLanguageCode.value),
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialBinding: BindingsBuilder(() {
        setStatusBarColor(transparentColor);
      }),
      onGenerateRoute: (settings) {
        if (settings.name.validate().split('/').last.isDigit()) {
          return MaterialPageRoute(
            builder: (context) {
              return SplashScreen(deepLink: settings.name.validate(), link: true);
            },
          );
        } else {
          return MaterialPageRoute(builder: (_) => SplashScreen());
        }
      },
      home: SplashScreen(),
      // ),
    );
  }
}