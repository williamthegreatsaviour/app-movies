import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/app_common.dart';
import '../../utils/colors.dart';
import 'components/menu.dart';
import 'dashboard_controller.dart';
import 'floting_action_bar/floating_action_controller.dart';
import 'floting_action_bar/floating_action_button.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key, required this.dashboardController});

  final DashboardController dashboardController;

  final FloatingController floatingController = Get.put(FloatingController());

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      child: Scaffold(
        extendBody: true,
        backgroundColor: appScreenBackgroundDark,
        extendBodyBehindAppBar: true,
        floatingActionButton: Obx(() {
          if (dashboardController.currentIndex.value == 0) {
            if (!appConfigs.value.enableTvShow && !appConfigs.value.enableMovie && !appConfigs.value.enableVideo) {
              return const Offstage();
            } else {
              return FloatingButton().paddingBottom(16);
            }
          } else {
            return const Offstage();
          }
        }),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Obx(
          () => IgnorePointer(
            ignoring: floatingController.isExpanded.value,
            child: dashboardController.screen[dashboardController.currentIndex.value],
          ),
        ),
        bottomNavigationBar: Obx(() {
          return Blur(
            blur: 30,
            borderRadius: radius(0),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: context.primaryColor.withValues(alpha: 0.02),
                indicatorColor: context.primaryColor.withValues(alpha: 0.1),
                labelTextStyle: WidgetStateProperty.all(primaryTextStyle(size: 14)),
                shadowColor: Colors.transparent,
                elevation: 0,
              ),
              child: NavigationBar(
                height: 60,
                surfaceTintColor: Colors.transparent,
                selectedIndex: dashboardController.currentIndex.value,
                backgroundColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                animationDuration: GetNumUtils(1000).milliseconds,
                onDestinationSelected: (index) async {
                  hideKeyboard(context);
                  floatingController.isExpanded(false);
                  await dashboardController.onBottomTabChange(index);
                  handleChangeTabIndex(index);
                },
                destinations: List.generate(
                  dashboardController.bottomNavItems.length,
                  (index) {
                    return navigationBarItemWidget(
                      dashboardController.bottomNavItems[index],
                      dashboardController.currentIndex.value == index,
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget navigationBarItemWidget(BottomBarItem navBar, bool isCurrentTab) {
    return NavigationDestination(
      selectedIcon: Icon(
        navBar.activeIcon,
        color: appColorPrimary,
        size: 20,
      ),
      icon: Icon(
        navBar.icon,
        color: iconColor,
        size: 20,
      ),
      label: navBar.title,
    );
  }

  Future<void> handleChangeTabIndex(int index) async {
    dashboardController.currentIndex(index);
  }
}