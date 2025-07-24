import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/category_list/movie_horizontal/poster_card_component.dart';
import 'package:streamit_laravel/utils/app_common.dart';

import '../../../../main.dart';
import '../../../home/model/dashboard_res_model.dart';

class EmptySearchListComponent extends StatelessWidget {
  final CategoryListModel sectionCategoryData;

  const EmptySearchListComponent({super.key, required this.sectionCategoryData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewAllWidget(
          label: locale.value.popularMovies,
          showViewAll: false,
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: sectionCategoryData.data.map(
            (e) {
              return SizedBox(
                height: 150,
                width: Get.width / 3 - 24,
                child: PosterCardComponent(
                  posterDetail: e,
                  isSearch: true,
                ),
              );
            },
          ).toList(),
        ).paddingSymmetric(horizontal: 16),
        60.height,
      ],
    );
  }
}