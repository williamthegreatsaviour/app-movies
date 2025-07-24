import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';

import '../../../components/cached_image_widget.dart';
import '../../../components/loader_widget.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../download_controller.dart';

class RemoveFromDownloadComponent extends StatelessWidget {
  final VoidCallback onRemoveTap;

  RemoveFromDownloadComponent({super.key, required this.onRemoveTap});

  final DownloadController downloadCont = Get.put(DownloadController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            padding: const EdgeInsets.all(32),
            mainAxisSize: MainAxisSize.min,
            children: [
              const CachedImageWidget(
                url: Assets.iconsIcDelete,
                height: 73,
                width: 100,
                color: appColorPrimary,
              ),
              30.height,
              Text(
                locale.value.removeSelectedFromDownloads.suffixText(value: '?'),
                style: primaryTextStyle(),
              ),
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppButton(
                    width: double.infinity,
                    text: locale.value.cancel,
                    color: lightBtnColor,
                    textStyle: appButtonTextStyleWhite,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                    onTap: () {
                      Get.back();
                    },
                  ).expand(),
                  16.width,
                  AppButton(
                    width: double.infinity,
                    text: locale.value.ok,
                    color: appColorPrimary,
                    textStyle: appButtonTextStyleWhite,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                    onTap: () {
                      onRemoveTap.call();
                    },
                  ).expand(),
                ],
              ),
            ],
          ),
        ),
        Obx(() => downloadCont.isLoading.isTrue ? const Positioned(left: 0, right: 0, bottom: 0, top: 0, child: LoaderWidget()) : const Offstage()),
      ],
    );
  }
}