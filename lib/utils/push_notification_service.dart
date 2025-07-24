import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import '../main.dart';
import 'constants.dart';

class PushNotificationService {
  Future<void> initFirebaseMessaging() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      initializePlatformSpecificNotificationChannel();

      registerNotificationListeners();

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

      await FirebaseMessaging.instance.subscribeToTopic(appNameTopic).then((value) {
        log("${FirebaseMsgConst.topicSubscribed}$appNameTopic");
      });
    }
  }

  Future<void> initializePlatformSpecificNotificationChannel() async {
    // Notification channel setup for Android
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    // Define notification channel
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      FirebaseMsgConst.notificationChannelIdKey,
      FirebaseMsgConst.notificationChannelNameKey,
      importance: Importance.high,
      enableLights: true,
      playSound: true,
      showBadge: true,
    );

    // Create notification channel
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    // Initialize FlutterLocalNotificationsPlugin
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(android: AndroidInitializationSettings('@drawable/ic_stat_ic_notification')),

    );
  }

  Future<void> registerFCMAndTopics() async {
    if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken == null) {
        Future.delayed(const Duration(seconds: 3), () async {
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        });
      }
      log("${FirebaseMsgConst.apnsNotificationTokenKey}\n$apnsToken");
    }
    FirebaseMessaging.instance.getToken().then((token) {
      log("${FirebaseMsgConst.fcmNotificationTokenKey}\n$token");
      subScribeToTopic();
    });
  }

  Future<void> subScribeToTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic("${FirebaseMsgConst.userWithUnderscoreKey}${loginUserData.value.id}").then((value) {
      log("${FirebaseMsgConst.topicSubscribed}${FirebaseMsgConst.userWithUnderscoreKey}${loginUserData.value.id}");
    });
  }

  Future<void> unsubscribeFirebaseTopic() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic('${FirebaseMsgConst.userWithUnderscoreKey}${loginUserData.value.id}').whenComplete(() {
      log("${FirebaseMsgConst.topicUnSubscribed}${FirebaseMsgConst.userWithUnderscoreKey}${loginUserData.value.id}");
    });
  }

  Future<void> handleNotificationClick(RemoteMessage message, {bool isForeGround = false}) async {
    printLogsNotificationData(message);
    if (isForeGround) {
      showNotification(currentTimeStamp(), message.notification!.title.validate(), message.notification!.body.validate(), message);
    } else {
      try {
        if (message.data.containsKey(FirebaseMsgConst.additionalDataKey)) {
          final additionalData = message.data[FirebaseMsgConst.additionalDataKey];
          if (additionalData != null) {
            if (additionalData!.containsKey(FirebaseMsgConst.idKey)) {
              /*  String? postId = additionalData![FirebaseMsgConst.idKey];
              String? postType = additionalData![FirebaseMsgConst.postTypeKey];*/
            }
          }
        }
      } catch (e) {
        log("${FirebaseMsgConst.onClickListener} $e");
      }
    }
  }

  Future<void> registerNotificationListeners() async {
    FirebaseMessaging.instance.setAutoInitEnabled(true).then((value) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        handleNotificationClick(message, isForeGround: true);
      }, onError: (e) {
        log("${FirebaseMsgConst.onMessageListen} $e");
      });

      // replacement for onResume: When the app is in the background and opened directly from the push notification.
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        handleNotificationClick(message);
      }, onError: (e) {
        log("${FirebaseMsgConst.onMessageOpened} $e");
      });

      // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          handleNotificationClick(message);
        }
      }, onError: (e) {
        log("${FirebaseMsgConst.onGetInitialMessage} $e");
      });
    }).onError((error, stackTrace) {
      log("${FirebaseMsgConst.onGetInitialMessage} $error");
    });
  }

  void showNotification(int id, String title, String message, RemoteMessage remoteMessage) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      FirebaseMsgConst.notificationChannelIdKey,
      FirebaseMsgConst.notificationChannelNameKey,
      importance: Importance.high,
      visibility: NotificationVisibility.public,
      autoCancel: true,
      playSound: true,
      priority: Priority.high,
      color: appColorPrimary,
      colorized: true,
      icon: '@drawable/ic_stat_ic_notification',

    );

    var darwinPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentSound: true,
      presentBanner: true,
      presentBadge: true,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
      macOS: darwinPlatformChannelSpecifics,
    );

    flutterLocalNotificationsPlugin.show(id, title, message, platformChannelSpecifics);
  }

  void printLogsNotificationData(RemoteMessage message) {
    log('${FirebaseMsgConst.notificationDataKey} : ${message.data}');
    log('${FirebaseMsgConst.notificationTitleKey} : ${message.notification!.title}');
    log('${FirebaseMsgConst.notificationBodyKey} : ${message.notification!.body}');
    log('${FirebaseMsgConst.messageDataCollapseKey} : ${message.collapseKey}');
    log('${FirebaseMsgConst.messageDataMessageIdKey} : ${message.messageId}');
  }
}