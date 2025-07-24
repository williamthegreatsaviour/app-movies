import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../setting/account_setting/components/logout_account_component.dart';
import '../../setting/account_setting/components/your_device/device_card.dart';
import '../../setting/account_setting/model/account_setting_response.dart';

class DeviceListComponent extends StatelessWidget {
  final List<YourDevice> loggedInDeviceList;
  final Function(bool logoutAll, String deviceId, String deviceName) onLogout;

  const DeviceListComponent({
    super.key,
    required this.loggedInDeviceList,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: boxDecorationDefault(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Constants.commonDialogBoxRadius),
          topRight: Radius.circular(Constants.commonDialogBoxRadius),
        ),
        border: Border(top: BorderSide(color: borderColor.withValues(alpha: 0.8))),
        color: appScreenBackgroundDark,
      ),
      child: Stack(
        children: [
          AnimatedScrollView(
            padding: EdgeInsets.only(bottom: 30, top: 16, right: 16, left: 16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    locale.value.otherDevices,
                    style: boldTextStyle(),
                  ).expand(),
                  16.width,
                  TextButton(
                    onPressed: () {
                      Get.bottomSheet(
                        isDismissible: true,
                        isScrollControlled: true,
                        enableDrag: false,
                        LogoutAccountComponent(
                          device: '',
                          deviceName: '',
                          logOutAll: true,
                          onLogout: (logoutAll) {
                            onLogout.call(true, '', '');
                          },
                        ),
                      );
                    },
                    child: Text(
                      locale.value.logOutAll,
                      style: commonSecondaryTextStyle(color: appColorPrimary),
                    ),
                  ),
                ],
              ),
              12.height,
              ...List.generate(
                loggedInDeviceList.length,
                (index) {
                  if (loggedInDeviceList[index].deviceId.isEmpty) {
                    return const Offstage();
                  } else {
                    return DeviceCard(
                      deviceDetail: loggedInDeviceList[index],
                      onDeviceLogout: () {
                        Get.bottomSheet(
                          isDismissible: true,
                          isScrollControlled: true,
                          enableDrag: false,
                          LogoutAccountComponent(
                            device: loggedInDeviceList[index].deviceId,
                            deviceName: loggedInDeviceList[index].deviceName,
                            logOutAll: false,
                            onLogout: (logoutAll) {
                              onLogout.call(false, loggedInDeviceList[index].deviceId, loggedInDeviceList[index].deviceName);
                            },
                          ),
                        );
                      },
                    ).paddingBottom(8);
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}