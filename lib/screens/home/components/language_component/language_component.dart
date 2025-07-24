import 'package:flutter/material.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/utils/colors.dart';
import '../../../../components/shimmer_widget.dart';
import '../../../../utils/app_common.dart';
import '../../../movie_list/movie_list_screen.dart';

class LanguageComponent extends StatelessWidget {
  final CategoryListModel languageDetails;
  final bool isLoading;

  const LanguageComponent({super.key, required this.languageDetails, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        viewAllWidget(
          label: languageDetails.name.capitalizeEachWord(),
          showViewAll: false,
        ),
        HorizontalList(
          physics: isLoading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          spacing: 10,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: languageDetails.data.length,
          itemBuilder: (context, index) {
            LangaugeModel language = languageDetails.data[index];
            if (isLoading) {
              return ShimmerWidget(
                height: 60,
                width: Get.width / 3 - 24,
              );
            } else {
              return InkWell(
                onTap: () {
                  Get.to(() => MovieListScreen(title: language.name), arguments: language.name);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: boxDecorationDefault(
                    color: cardDarkColor,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: boxDecorationDefault(
                          shape: BoxShape.circle,
                          color: borderColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          language.name[0].toUpperCase(),
                          style: boldTextStyle(
                            size: 14,
                          ),
                        ),
                      ),
                      12.width,
                      Text(
                        language.name,
                        style: boldTextStyle(
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    ).paddingSymmetric(vertical: 8);
  }
}
