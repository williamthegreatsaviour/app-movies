import 'package:flutter/material.dart';
import 'package:flutter_chrome_cast/_discovery_manager/discovery_manager.dart';
import 'package:flutter_chrome_cast/entities/cast_device.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../main.dart';
import '../empty_error_state_widget.dart';
import 'controller/fc_cast_controller.dart';

class AvailableDevicesForCast extends StatefulWidget {
  final Function(GoogleCastDevice)? onTap;

  const AvailableDevicesForCast({super.key, this.onTap});

  @override
  State<AvailableDevicesForCast> createState() => _AvailableDevicesForCastState();
}

class _AvailableDevicesForCastState extends State<AvailableDevicesForCast> {
  FCCast cast = Get.put(FCCast());

  @override
  void initState() {
    super.initState();
    findAvailableDevices();
  }

  Future<void> findAvailableDevices() async {
    log("======================== 1.  Find Available Devices ========================");
    cast.startDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: boxDecorationDefault(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        border: Border(top: BorderSide(color: borderColor.withValues(alpha: 0.8))),
        color: appScreenBackgroundDark,
      ),
      child: AnimatedScrollView(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        listAnimationType: commonListAnimationType,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: <Widget>[
          Row(
            children: [
              Row(
                children: [
                  Text(
                    locale.value.searchingForDevice,
                    style: primaryTextStyle(size: 20),
                  ),
                  Obx(
                    () => const LoaderWidget(
                      size: 20,
                    ).visible(cast.isSearchingForDevice.value).paddingLeft(8),
                  ),
                  Obx(
                    () {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: darkGrayColor)),
                        child: Text(locale.value.retry, style: secondaryTextStyle()),
                      ).onTap(() => cast.startDiscovery()).visible(!cast.isSearchingForDevice.value);
                    },
                  )
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Get.back();
                },
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.close,
                  color: iconColor,
                ),
              )
            ],
          ),
          StreamBuilder<List<GoogleCastDevice>>(
            stream: GoogleCastDiscoveryManager.instance.devicesStream,
            builder: (context, snapshot) {
              final devices = snapshot.data ?? [];
              if (devices.isEmpty && cast.isSearchingForDevice.isFalse) {
                return NoDataWidget(
                  titleTextStyle: boldTextStyle(color: white),
                  subTitleTextStyle: primaryTextStyle(color: white),
                  title: locale.value.noDeviceAvailable,
                  retryText: "",
                  imageWidget: const EmptyStateWidget(),
                ).paddingOnly(
                  bottom: 28,
                );
              } else {
                return ListView.builder(
                  itemCount: devices.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    GoogleCastDevice device = devices[index];
                    return ListTile(
                      selectedTileColor: appColorPrimary,
                      tileColor: context.cardColor,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        device.friendlyName,
                        style: primaryTextStyle(size: 16),
                      ),
                      subtitle: Text(
                        device.modelName.validate(),
                        style: secondaryTextStyle(),
                      ),
                      onTap: () async {
                        widget.onTap!(device);
                      },
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}