import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/setting/account_setting/model/account_setting_response.dart';
import '../../../../../main.dart';
import 'device_card.dart';

class YourDeviceComponent extends StatelessWidget {
  final YourDevice deviceDet;

  const YourDeviceComponent({super.key, required this.deviceDet});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          locale.value.yourDevice,
          style: boldTextStyle(),
        ),
        12.height,
        DeviceCard(
          deviceDetail: deviceDet,
          onDeviceLogout: () {},
        ),
        32.height,
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
