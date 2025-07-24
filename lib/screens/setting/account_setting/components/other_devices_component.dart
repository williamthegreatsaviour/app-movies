import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/setting/account_setting/components/your_device/device_card.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../../main.dart';
import '../../../../utils/colors.dart';
import '../model/account_setting_response.dart';
import 'logout_account_component.dart';

class OtherDevicesComponent extends StatelessWidget {
  final List<YourDevice> devicesDetail;

  final Function(bool logoutAll, String deviceId, String deviceName) onLogout;

  const OtherDevicesComponent({super.key, required this.devicesDetail, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    if (devicesDetail.validate().isEmpty) {
      return Offstage();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
                    logOutAll: true,
                    onLogout: (logoutAll) {
                      onLogout.call(true, '', '');
                    },
                    device: '',
                    deviceName: '',
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
        AnimatedListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: devicesDetail.length,
          itemBuilder: (context, index) {
            if (devicesDetail[index].deviceId.isEmpty) {
              return const Offstage();
            } else {
              return DeviceCard(
                deviceDetail: devicesDetail[index],
                onDeviceLogout: () {
                  Get.bottomSheet(
                    isDismissible: true,
                    isScrollControlled: true,
                    enableDrag: false,
                    LogoutAccountComponent(
                      device: devicesDetail[index].deviceId,
                      deviceName: devicesDetail[index].deviceName,
                      logOutAll: false,
                      onLogout: (logoutAll) {
                        onLogout.call(logoutAll, devicesDetail[index].deviceId, devicesDetail[index].deviceName);
                      },
                    ),
                  );
                },
              ).paddingBottom(8);
            }
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}