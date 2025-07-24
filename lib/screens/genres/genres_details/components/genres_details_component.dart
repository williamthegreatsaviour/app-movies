import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../utils/app_common.dart';
import '../../../../utils/colors.dart';
import '../../model/genres_model.dart';

class GenresDetailsComponent extends StatelessWidget {
  final GenreModel generDetail;
  const GenresDetailsComponent({super.key, required this.generDetail});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CachedImageWidget(
              url: generDetail.poster,
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
              topLeftRadius: 35,
              topRightRadius: 35,
            ),
            IgnorePointer(
              ignoring: true,
              child: Container(
                height: 280,
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
        ),
        10.height,
        Text(
          generDetail.name,
          style: boldTextStyle(
            size: 16,
            color: white,
          ),
        ).paddingSymmetric(horizontal: 16),
        8.height,
        readMoreTextWidget(
          generDetail.description
        ).paddingSymmetric(horizontal: 16),
        20.height,
        Text(
          "${locale.value.moviesOf}${generDetail.name}",
          style: boldTextStyle(size: 16, color: white),
        ).paddingSymmetric(horizontal: 16),
        10.height,
      ],
    );
  }
}