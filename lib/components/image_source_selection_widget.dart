import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../main.dart';

class ImageSourceSelectionComponent extends StatelessWidget {
  final VoidCallback onGalleySelected;
  final VoidCallback onCameraSelected;

  const ImageSourceSelectionComponent({super.key, required this.onCameraSelected, required this.onGalleySelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        16.height,
        Text(locale.value.chooseImageSource, style: primaryTextStyle(color: primaryTextColor, size: 22)),
        8.height,
        SettingItemWidget(
          title: locale.value.gallery,
          leading: const Icon(Icons.image, color: white),
          titleTextColor: white,
          onTap: onGalleySelected,
        ),
        SettingItemWidget(
          title: locale.value.camera,
          leading: const Icon(Icons.camera, color: white),
          titleTextColor: white,
          onTap: onCameraSelected,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
