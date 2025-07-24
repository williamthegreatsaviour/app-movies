import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/movie_list/movie_list_screen.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import '../../../main.dart';
import '../../tv_show/tvshow_list_screen.dart';
import '../../video/video_list_screen.dart';
import 'floating_action_controller.dart';

class FloatingButton extends StatelessWidget {
  FloatingButton({super.key});

  final FloatingController floatingController = Get.find<FloatingController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Positioned(
            bottom: 44,
            top: -100,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                height: 500,
                width: double.infinity,
                foregroundDecoration: BoxDecoration(
                  gradient: floatingController.isExpanded.isTrue
                      ? LinearGradient(
                          colors: [black.withValues(alpha: 0.0), black.withValues(alpha: 0.2), black.withValues(alpha: 0.4), black.withValues(alpha: 0.9)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const Spacer(),
              24.height,
              if (floatingController.isExpanded.isTrue) ...[
                if (appConfigs.value.enableVideo) _buildFab(locale.value.videos),
                if (appConfigs.value.enableMovie) _buildFab(locale.value.movies),
                if (appConfigs.value.enableTvShow) _buildFab(locale.value.tVShows),
              ],
              24.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: floatingController.toggle,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(32),
                        color: white,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            locale.value.all,
                            style: boldTextStyle(size: 16, color: black, weight: FontWeight.w600),
                          ),
                          6.width,
                          AnimatedIcon(
                            size: 18,
                            color: darkGrayColor,
                            icon: AnimatedIcons.menu_close,
                            progress: floatingController.animation,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 56)
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildFab(String label) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      InkWell(
        onTap: () {
          final FloatingController floatingController = Get.put(FloatingController());
          if (label == locale.value.videos) {
            Get.to(() => VideoListScreen());
          } else if (label == locale.value.tVShows) {
            Get.to(() => TvShowListScreen());
          } else {
            Get.to(() => MovieListScreen());
          }
          floatingController.toggle();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: boxDecorationDefault(
            borderRadius: BorderRadius.circular(32),
            color: white,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: boldTextStyle(size: 16, color: black, weight: FontWeight.w600),
          ),
        ),
      ),
    ],
  );
}