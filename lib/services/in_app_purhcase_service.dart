import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../network/core_api.dart';

class InAppPurchaseService {
  Future<void> init() async {
    try {
      await Purchases.setLogLevel(LogLevel.error);
      final String apiKey = isApple ? appConfigs.value.appleApiKey : appConfigs.value.googleApiKey;

      if (apiKey.isNotEmpty) {
        PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
        await Purchases.configure(configuration);
        log('In App Purchase Configuration Successful');
        setValue(SharedPreferenceConst.HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE, true);
        if (isLoggedIn.value && !getBoolAsync(SharedPreferenceConst.HAS_IN_APP_USER_LOGIN_DONE_AT_LEASE_ONCE)) loginToRevenueCate();
      } else {}
    } catch (e) {
      log('In App Purchase Configuration Failed: ${e.toString()}');
    }
    log('In App Purchase Init Complete');
  }

  Future<void> loginToRevenueCate() async {
    try {
      await Purchases.logIn(loginUserData.value.email);
      log('In App Purchase User Login Successful');
      setValue(SharedPreferenceConst.HAS_IN_APP_USER_LOGIN_DONE_AT_LEASE_ONCE, true);
      getCustomerInfo();
    } catch (e) {
      log('In App Purchase User Login Failed: ${e.toString()}');
    }
  }

  Future<CustomerInfo?> getCustomerInfo({bool restore = false, BuildContext? context}) async {
    Purchases.invalidateCustomerInfoCache();
    await Purchases.getCustomerInfo().then(
      (customerData) {
        if (isLoggedIn.value) checkSubscriptionSync();
        return customerData;
      },
    );
    return null;
  }

  Future<Offerings?> getStoreSubscriptionPlanList() async {
    if (!getBoolAsync(SharedPreferenceConst.HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE)) {
      await init();
    }
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      if (e is PlatformException) {
        toast(e.message, print: true);
      } else {
        log(e.toString());
      }
    }
    return null;
  }

  Future<void> startPurchase({
    required Package selectedRevenueCatPackage,
    required Function(String transacationId) onComplete,
  }) async {
    if (!getBoolAsync(SharedPreferenceConst.HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE)) {
      await init();
    } else {
      await Purchases.purchasePackage(
        selectedRevenueCatPackage,
        googleProductChangeInfo: currentSubscription.value.activePlanInAppPurchaseIdentifier.isNotEmpty ? GoogleProductChangeInfo(currentSubscription.value.activePlanInAppPurchaseIdentifier) : null,
      ).then(
        (value) {
          onComplete.call('');
        },
      ).catchError((e) {
        if (e is PlatformException) {
          toast(e.message);
        } else {
          if (e is PurchasesError) {
            toast(e.message);
          } else {
            toast(e.toString());
          }
        }
      });
    }
  }

  Future<void> checkSubscriptionSync() async {
    //Case check current subscription on AppStore/ PlayStore
    if (!getBoolAsync(SharedPreferenceConst.HAS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE)) {
      await init().then(
        (value) async {
          await loginToRevenueCate().then(
            (value) {
              checkSubscriptionSync();
            },
          );
        },
      );
    } else {
      await getCustomerInfo().then(
        (customerData) {
          if (currentSubscription.value.activePlanInAppPurchaseIdentifier.isNotEmpty && currentSubscription.value.status == SubscriptionStatus.active) {
            if (customerData != null) {
              if (customerData.activeSubscriptions.isEmpty) {
                cancelCurrentSubscription();
              } else {
                if (!customerData.activeSubscriptions.contains(currentSubscription.value.activePlanInAppPurchaseIdentifier)) {
                  retryPendingSubscriptionData();
                }
              }
            }
          }
        },
      );
    }
  }

  Future<void> retryPendingSubscriptionData() async {
    SubscriptionPlanModel? planReq = await getPendingSubscriptionData();
    if (planReq != null) {
      await CoreServiceApis.saveSubscriptionDetails(
        request: {
          "plan_id": planReq.planId,
          "user_id": loginUserData.value.id,
          "identifier": planReq.name.validate(),
          "payment_status": PaymentStatus.PAID,
          "payment_type": PaymentMethods.PAYMENT_METHOD_IN_APP_PURCHASE,
          "transaction_id": '',
          'device_id': yourDevice.value.deviceId,
        },
      ).then(
        (value) {
          clearPendingSubscriptionData();
        },
      ).catchError((e) {
        setValue(SharedPreferenceConst.IS_SUBSCRIPTION_PURCHASE_RESTORE_REQUIRED, true);
        setValue(SharedPreferenceConst.PURCHASE_REQUEST, planReq.toJson());
        log(e.toString());
      });
    } else {}
  }

  Future<SubscriptionPlanModel?> getPendingSubscriptionData() async {
    if (getStringAsync(SharedPreferenceConst.PURCHASE_REQUEST).isNotEmpty) {
      return SubscriptionPlanModel.fromJson(jsonDecode(getStringAsync(SharedPreferenceConst.PURCHASE_REQUEST)));
    }
    return null;
  }

  Future<void> clearPendingSubscriptionData() async {
    removeKey(SharedPreferenceConst.HAS_PURCHASE_STORED);
    removeKey(SharedPreferenceConst.PURCHASE_REQUEST);
    removeKey(SharedPreferenceConst.IS_SUBSCRIPTION_PURCHASE_RESTORE_REQUIRED);
  }

  void cancelCurrentSubscription() {
    CoreServiceApis.cancelSubscription(request: {"id": currentSubscription.value.id, "user_id": loginUserData.value.id})
        .then((value) async {
          final userData = getJSONAsync(SharedPreferenceConst.USER_DATA);
          userData['plan_details'] = SubscriptionPlanModel().toJson();
          currentSubscription(SubscriptionPlanModel());
          isCastingSupported(false);
          currentSubscription.value.activePlanInAppPurchaseIdentifier = '';
          setValue(SharedPreferenceConst.USER_SUBSCRIPTION_DATA, '');
        })
        .catchError((e) {})
        .whenComplete(() {});
  }
}