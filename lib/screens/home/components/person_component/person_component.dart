import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/screens/person/person_detail_screen.dart';
import 'package:streamit_laravel/utils/app_common.dart';

import '../../../../components/shimmer_widget.dart';
import '../../../person/model/person_model.dart';
import '../../../person/person_controller.dart';
import '../../../person/person_list/person_list_screen.dart';
import 'person_card.dart';

class PersonComponent extends StatelessWidget {
  final CategoryListModel personDetails;
  final double? height;
  final double? width;

  final bool isLoading;

  const PersonComponent({
    super.key,
    required this.personDetails,
    this.height,
    this.width,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        viewAllWidget(
          showViewAll: (personDetails.data.length > 6),
          label: personDetails.name,
          onButtonPressed: () {
            Get.to(() => PersonListScreen(title: personDetails.name.validate()));
          },
        ),
        HorizontalList(
          physics: isLoading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          runSpacing: 10,
          spacing: 10,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: personDetails.data.length,
          itemBuilder: (context, index) {
            PersonModel movie = personDetails.data[index];
            if (isLoading) {
              return ShimmerWidget(
                height: height ?? 140,
                width: width ?? 100,
                radius: 6,
              );
            } else {
              return InkWell(
                onTap: () {
                  final PersonController personCont = Get.put(PersonController());
                  personCont.actorId(movie.id);
                  personCont.getPersonMovieDetails();
                  Get.to(
                    () => PersonDetailScreen(personDet: movie, isHomeScreen: true),
                  );
                },
                child: PersonCard(personDet: movie),
              );
            }
          },
        ),
      ],
    ).paddingSymmetric(vertical: 8);
  }
}
