import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/screens/genres/model/genres_model.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../../../components/cached_image_widget.dart';

class GenreProfileComponent extends StatelessWidget {
  final GenreModel genreDetail;

  const GenreProfileComponent({super.key, required this.genreDetail});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        /* Hero(
          tag: "$genresTag${generDetail.id}",
          transitionOnUserGestures: true,
          child: CachedImageWidget(
            url: generDetail.poster,
            height: Get.height * 0.45,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),*/
        CachedImageWidget(
          url: genreDetail.poster,
          height: Get.height * 0.45,
          width: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        IgnorePointer(
          ignoring: true,
          child: Container(
            height: Get.height * 0.45,
            width: double.infinity,
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [appScreenBackgroundDark.withValues(alpha: 0.0), appScreenBackgroundDark.withValues(alpha: 0.0), appScreenBackgroundDark.withValues(alpha: 0.6), appScreenBackgroundDark.withValues(alpha: 1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
