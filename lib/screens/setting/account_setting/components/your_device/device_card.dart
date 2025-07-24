import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/setting/account_setting/model/account_setting_response.dart';

import '../../../../../main.dart';
import '../../../../../utils/app_common.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/common_base.dart';

class DeviceCard extends StatelessWidget {
  final YourDevice deviceDetail;

  final VoidCallback onDeviceLogout;


  const DeviceCard({super.key, required this.deviceDetail, required this.onDeviceLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 16, top: 16),
      decoration: boxDecorationDefault(
        color: canvasColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Marquee(
                child: Text(
                  deviceDetail.deviceName,
                  style: commonW600PrimaryTextStyle(),
                ),
              ),
              6.height,
              if (deviceDetail.updatedAt.isNotEmpty)
                Text(
                  "${locale.value.lastUsed}: ${deviceDetail.deviceId == yourDevice.value.deviceId ? timeFormatInHour(DateTime.now().toUtc().toIso8601String()) : timeFormatInHour(deviceDetail.updatedAt)}",
                  style: secondaryTextStyle(),
                ),
            ],
          ).expand(),
          if (deviceDetail.deviceId != yourDevice.value.deviceId)
            TextButton(
              onPressed: onDeviceLogout,
              child: Text(
                locale.value.logout,
                style: commonW600SecondaryTextStyle(color: appColorPrimary),
              ),
            ),
        ],
      ),
    );
  }
}
