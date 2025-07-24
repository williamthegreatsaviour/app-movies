import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/screens/setting/faq/components/f_a_q_card.dart';
import 'package:streamit_laravel/screens/setting/model/faq_model.dart';
import 'package:streamit_laravel/screens/setting/setting_controller.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/empty_error_state_widget.dart';

class FAQScreen extends StatelessWidget {
  final List<FAQModel> faqList;
  final SettingController settingController;

  const FAQScreen({super.key, required this.faqList, required this.settingController});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBartitleText: locale.value.faqs,
      topBarBgColor: transparentColor,
      isLoading: settingController.isLoading,
      body: Obx(
        () => AnimatedScrollView(
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: EdgeInsets.only(bottom: 60, top: 16, left: 16, right: 16),
          refreshIndicatorColor: appColorPrimary,
          physics: AlwaysScrollableScrollPhysics(),
          onSwipeRefresh: () {
            settingController.page(1);
            return settingController.getFAQListAPI();
          },
          onNextPage: () {
            if (!settingController.mIsLastPage.value) {
              settingController.page++;
              settingController.getFAQListAPI();
            }
          },
          children: [
            if (settingController.faqList.isEmpty)
              SizedBox(
                height: Get.height * 0.65,
                width: Get.width,
                child: NoDataWidget(
                  titleTextStyle: boldTextStyle(color: white),
                  subTitleTextStyle: primaryTextStyle(color: white),
                  title: locale.value.noFAQsfound,
                  retryText: locale.value.reload,
                  onRetry: () {
                    settingController.getFAQListAPI();
                  },
                  imageWidget: const EmptyStateWidget(),
                ).paddingSymmetric(horizontal: 16).center(),
              ),
            if (settingController.faqList.isNotEmpty)
              ...faqList.map(
                (e) {
                  return FAQCard(faqData: e);
                },
              )
          ],
        ),
      ),
    );
  }
}
