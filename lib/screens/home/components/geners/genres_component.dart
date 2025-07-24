import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/utils/app_common.dart';

import '../../../../components/shimmer_widget.dart';
import '../../../genres/genres_details/genres_details_controller.dart';
import '../../../genres/genres_details/genres_details_screen.dart';
import '../../../genres/genres_list_screen.dart';
import '../../../genres/model/genres_model.dart';
import 'genres_card.dart';

class GenreComponent extends StatelessWidget {
  final CategoryListModel genresDetails;
  final bool isLoading;

  const GenreComponent({super.key, required this.genresDetails, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        viewAllWidget(
          label: genresDetails.name,
          showViewAll: genresDetails.data.isNotEmpty,
          onButtonPressed: () {
            Get.to(() => GenresListScreen(title: genresDetails.name));
          },
        ),
        if (genresDetails.data.length < 6) 16.height,
        HorizontalList(
          physics: isLoading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          runSpacing: 10,
          spacing: 10,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: genresDetails.data.length,
          itemBuilder: (context, index) {
            GenreModel movie = genresDetails.data[index];

            if (isLoading) {
              return ShimmerWidget(
                height: 120,
                width: 100,
              ).cornerRadiusWithClipRRect(6);
            }
            return InkWell(
              onTap: () {
                GenresDetailsController genDetCont = Get.put(GenresDetailsController());
                genDetCont.genresId(movie.id);
                genDetCont.getGenresDetails();
                Get.to(() => GenresDetailsScreen(generDetails: movie));
              },
              child: GenresCard(cardDet: movie),
            );
          },
        ),
      ],
    ).paddingSymmetric(vertical: 8);
  }
}
