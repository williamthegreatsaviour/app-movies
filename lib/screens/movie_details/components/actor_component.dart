import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/person/person_detail_screen.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../components/cached_image_widget.dart';
import '../../person/model/person_model.dart';
import '../../person/person_controller.dart';

class ActorComponent extends StatelessWidget {
  final List<PersonModel> castDetails;
  final String title;
  final double? height;
  final double? width;

  const ActorComponent({super.key, required this.title, required this.castDetails, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: commonW600PrimaryTextStyle(size: 16),
        ),
        16.height,
        HorizontalList(
          itemCount: castDetails.length,
          runSpacing: 10,
          spacing: 10,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            PersonModel movie = castDetails[index];
            return InkWell(
              onTap: () {
                /// calling the live stream to pause pod player
                LiveStream().emit(podPlayerPauseKey);

                final PersonController personCont = Get.isRegistered<PersonController>() ? Get.find<PersonController>() : Get.put(PersonController());
                personCont.page(1);
                personCont.actorId(movie.id);
                personCont.getPersonMovieDetails();
                Get.to(() => PersonDetailScreen(personDet: movie, isHomeScreen: false));
              },
              child: Stack(
                children: [
                  CachedImageWidget(
                    url: movie.profileImage,
                    height: height ?? 140,
                    width: width ?? 96,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    radius: 6,
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: Container(
                      height: height ?? 140,
                      width: width ?? 96,
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
                    left: 8,
                    right: 8,
                    child: Marquee(
                      child: Text(
                        movie.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: boldTextStyle(size: 12, color: white),
                      ),
                    ).center(),
                  )
                ],
              ),
            );
          },
        ),
      ],
    ).paddingSymmetric(vertical: 12, horizontal: 10);
  }
}
