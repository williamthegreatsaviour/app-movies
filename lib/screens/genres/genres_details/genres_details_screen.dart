import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/genres/genres_details/genres_details_controller.dart';

import '../../../components/app_scaffold.dart';
import '../../../utils/colors.dart';
import '../model/genres_model.dart';
import 'components/genres_movies_component.dart';
import 'components/genre_profile_component.dart';

class GenresDetailsScreen extends StatelessWidget {
  final GenreModel generDetails;

  GenresDetailsScreen({super.key, required this.generDetails});

  final GenresDetailsController genDetCont = Get.put(GenresDetailsController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      topBarBgColor: transparentColor,
      hideAppBar: true,
      body: NestedScrollView(
        controller: genDetCont.scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: Get.height * 0.45,
              pinned: true,
              backgroundColor: Colors.transparent,
              leading: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(14),
                decoration: boxDecorationDefault(
                  shape: BoxShape.circle,
                  color: btnColor,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                  ),
                ),
              ),
              title: Marquee(
                child: Text(
                  generDetails.name.capitalizeEachWord(),
                  style: boldTextStyle(size: 18, ),
                ),
              ),
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: GenreProfileComponent(genreDetail: generDetails),
                  );
                },
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: GenresMoviesComponent(genreDetail: generDetails),
        ),
      ),
    );
  }
}
