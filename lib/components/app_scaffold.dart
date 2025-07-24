import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/app_common.dart';

import '../utils/colors.dart';
import '../utils/common_base.dart';
import 'body_widget.dart';
import 'loader_widget.dart';

class AppScaffold extends StatelessWidget {
  final bool hideAppBar;
  final Widget? leadingWidget;
  final Widget? appBarTitle;
  final List<Widget>? actions;
  final bool isCenterTitle;
  final bool automaticallyImplyLeading;
  final double? appBarelevation;
  final String? appBartitleText;
  final Color? appBarbackgroundColor;
  final Widget body;
  final Color? scaffoldBackgroundColor;
  final RxBool? isLoading;
  final Widget? bottomNavBar;
  final Widget? fabWidget;
  final bool hasLeadingWidget;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool? resizeToAvoidBottomPadding;
  final bool? extendBodyBehindAppBar;

  const AppScaffold({
    super.key,
    this.hideAppBar = false,
    //
    this.leadingWidget,
    this.appBarTitle,
    this.actions,
    this.appBarelevation = 0,
    this.appBartitleText,
    this.appBarbackgroundColor,
    this.isCenterTitle = false,
    this.hasLeadingWidget = true,
    this.automaticallyImplyLeading = false,
    this.extendBodyBehindAppBar = false,
    //
    required this.body,
    this.isLoading,
    //
    this.bottomNavBar,
    this.fabWidget,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomPadding,
    this.scaffoldBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
      appBar: hideAppBar
          ? null
          : PreferredSize(
              preferredSize: Size(Get.width, 52),
              child: AppBar(
                elevation: appBarelevation,
                automaticallyImplyLeading: automaticallyImplyLeading,
                centerTitle: isCenterTitle,
                titleSpacing: 2,
                title: appBarTitle ??
                    Text(
                      appBartitleText ?? "",
                      style: commonW600PrimaryTextStyle(size: 18),
                    ).paddingLeft(hasLeadingWidget ? 0 : 16),
                actions: actions,
                leading: leadingWidget ?? (hasLeadingWidget ? backButton() : null),
              ).paddingTop(0),
            ),
      backgroundColor: scaffoldBackgroundColor ?? context.scaffoldBackgroundColor,
      body: Body(
        isLoading: isLoading ?? false.obs,
        child: body,
      ),
      bottomNavigationBar: bottomNavBar,
      floatingActionButton: fabWidget,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

class AppScaffoldNew extends StatelessWidget {
  final Widget body;
  final Widget? appBarChild;
  final Widget? leadingWidget;
  final String? appBartitleText;
  final bool hasLeadingWidget;
  final List<Widget>? actions;
  final double? appBarVerticalSize;
  final Color? topBarBgColor;
  final Color? bottomBarBgColor;
  final bool? resizeToAvoidBottomPadding;
  final Color? scaffoldBackgroundColor;
  final RxBool? isLoading;
  final List<Widget> widgetsStackedOverBody;
  final bool hideAppBar;
  final bool isBlurBackgroundinLoader;
  final Clip clipBehaviorSplitRegion;
  final RxInt? currentPage;

  const AppScaffoldNew({
    super.key,
    required this.body,
    this.appBarChild,
    this.leadingWidget,
    this.appBartitleText,
    this.hasLeadingWidget = true,
    this.actions,
    this.appBarVerticalSize,
    this.topBarBgColor,
    this.bottomBarBgColor,
    this.resizeToAvoidBottomPadding,
    this.scaffoldBackgroundColor,
    this.isLoading,
    this.widgetsStackedOverBody = const [],
    this.hideAppBar = false,
    this.isBlurBackgroundinLoader = false,
    this.clipBehaviorSplitRegion = Clip.antiAlias,
    this.currentPage,
  });

  double get topBarHeight => hideAppBar ? 0 : appBarVerticalSize ?? 60;

  Widget get topBarComponent =>
      appBarChild ??
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    appBartitleText ?? "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: boldTextStyle(size: 18),
                  ).expand(),
                ],
              ).paddingSymmetric(horizontal: hasLeadingWidget ? 50 : 16),
              Positioned.directional(
                textDirection: isRTL.value ? TextDirection.rtl : TextDirection.ltr,
                start: 0,
                child: leadingWidget ??
                    (hasLeadingWidget
                        ? IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.arrow_back_ios_new_outlined, color: white, size: 20),
                          )
                        : const Offstage()),
              ),
              Positioned.directional(
                end: 0,
                textDirection: isRTL.value ? TextDirection.rtl : TextDirection.ltr,
                child: Row(
                  children: actions ?? [],
                ),
              )
            ],
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
      backgroundColor: scaffoldBackgroundColor ?? context.scaffoldBackgroundColor,
      body: SafeArea(
        top: !isPipModeOn.value,
        child: Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(color: topBarBgColor ?? appColorPrimary),
              child: Obx(
                () => Stack(
                  fit: StackFit.expand,
                  children: [
                    if (!isPipModeOn.value)
                      Positioned(
                        height: topBarHeight,
                        width: Get.width,
                        child: topBarComponent,
                      ),
                    Container(
                      clipBehavior: clipBehaviorSplitRegion,
                      margin: isPipModeOn.value ? EdgeInsets.zero : EdgeInsets.only(top: topBarHeight),
                      decoration: boxDecorationDefault(
                        color: scaffoldBackgroundColor ?? context.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                      ),
                      child: body,
                    ),
                    ...widgetsStackedOverBody,
                  ],
                ),
              ),
            ),
            Obx(() => currentPage != null && currentPage!.value > 1
                ? Positioned(bottom: 32, left: 0, right: 0, child: LoaderWidget(isBlurBackground: isBlurBackgroundinLoader).visible((isLoading ?? false.obs).value))
                : LoaderWidget(isBlurBackground: isBlurBackgroundinLoader).center().visible((isLoading ?? false.obs).value))
          ],
        ),
      ),
    );
  }
}