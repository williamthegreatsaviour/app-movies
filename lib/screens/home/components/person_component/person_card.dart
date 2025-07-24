import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../../components/cached_image_widget.dart';
import '../../../person/model/person_model.dart';

class PersonCard extends StatelessWidget {
  final PersonModel personDet;
  final double? height;
  final double? width;

  const PersonCard({super.key, required this.personDet, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hero(tag: "$actorTag${personDet.id}",child: CachedImageWidget(url: personDet.profileImage, height: height ?? 140, width: width ?? 100, fit: BoxFit.cover, alignment: Alignment.topCenter, radius: 6)),
        CachedImageWidget(
          url: personDet.profileImage,
          height: height ?? 140,
          width: width ?? 100,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          radius: 6,
        ),
        IgnorePointer(
          ignoring: true,
          child: Container(
            height: height ?? 140,
            width: width ?? 100,
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [black.withValues(alpha: 0.0), black.withValues(alpha: 0.0), black.withValues(alpha: 0.5), black.withValues(alpha: 1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Text(
            personDet.name,
            textAlign: TextAlign.center,
            style: boldTextStyle(size: 12, color: white),
          ),
        )
      ],
    );
  }
}
