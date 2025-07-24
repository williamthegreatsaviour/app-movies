import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../genres/model/genres_model.dart';

class GenresCard extends StatelessWidget {
  final GenreModel cardDet;
  final double? height;
  final double? width;

  const GenresCard({super.key, required this.cardDet, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /*Hero(
          tag: "$genresTag${cardDet.id}",
          child: CachedImageWidget(
            url: cardDet.poster,
            height: height ?? 120,
            width: width ?? 100,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            radius: 6,
          ),
        ),*/
        CachedImageWidget(
          url: cardDet.poster,
          height: height ?? 120,
          width: width ?? 100,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          radius: 6,
        ),
        IgnorePointer(
          ignoring: true,
          child: Container(
            height: height ?? 120,
            width: width ?? 100,
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [black.withValues(alpha: 0.0), black.withValues(alpha: 0.0), black.withValues(alpha: 0.5), black.withValues(alpha: 0.9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 2,
          right: 2,
          child: Center(
            child: Marquee(
              child: Text(
                cardDet.name,
                textAlign: TextAlign.center,
                style: boldTextStyle(
                  size: 12,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
