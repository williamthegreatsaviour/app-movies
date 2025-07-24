import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../../components/cached_image_widget.dart';
import '../model/person_model.dart';

class PersonProfileWidget extends StatelessWidget {
  final PersonModel personDetail;

  const PersonProfileWidget({super.key, required this.personDetail});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        /* Hero(
          tag: "$actorTag${personDet.id}",
          child: CachedImageWidget(
            url: personDet.profileImage,
            height: Get.height * 0.6,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),*/
        CachedImageWidget(
          url: personDetail.profileImage,
          height: Get.height * 0.6,
          width: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        IgnorePointer(
          ignoring: true,
          child: Container(
            height: Get.height * 0.61,
            width: double.infinity,
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  canvasColor.withValues(alpha: 0.0),
                  canvasColor.withValues(alpha: 0.0),
                  canvasColor.withValues(alpha: 0.6),
                  canvasColor.withValues(alpha: 1),
                ],
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
