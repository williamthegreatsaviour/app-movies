import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../model/live_tv_dashboard_response.dart';
import 'live_horizontal_list.dart';

class LiveCategoryListComponent extends StatelessWidget {
  final List<CategoryData> liveCategoryList;
  const LiveCategoryListComponent({super.key, required this.liveCategoryList});

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      listAnimationType: ListAnimationType.FadeIn,
      itemCount: liveCategoryList.length,
      itemBuilder: (context, index) {
        CategoryData category = liveCategoryList[index];
        return LiveHorizontalComponent(movieDet: category);
      },
    );
  }
}
