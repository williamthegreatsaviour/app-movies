import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/home/home_controller.dart';
import 'package:streamit_laravel/screens/setting/setting_controller.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import '../../../components/app_scaffold.dart';
import '../../../locale/app_localizations.dart';
import '../../../locale/languages.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';

class LanguageScreen extends StatelessWidget {
  final SettingController settingController;
  const LanguageScreen({super.key, required this.settingController});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: false.obs,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBartitleText: locale.value.language,
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 30, top: 16),
        itemBuilder: (_, index) {
          LanguageDataModel data = localeLanguageList[index];

          return SettingItemWidget(
            title: data.name.validate(),
            subTitle: data.subTitle,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            titleTextStyle: primaryTextStyle(),
            leading: (data.flag.validate().isNotEmpty)
                ? data.flag.validate().startsWith('http')
                    ? Image.network(data.flag.validate(), width: 24)
                    : Image.asset(data.flag.validate(), width: 24)
                : null,
            trailing: Obx(
              () => Container(
                padding: const EdgeInsets.all(2),
                decoration: boxDecorationDefault(shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 15, color: Colors.black),
              ).visible(selectedLanguageCode.value == data.languageCode.validate()),
            ),
            splashColor: appColorPrimary.withValues(alpha: 0.2),
            borderRadius: 8,
            highlightColor: appColorPrimary.withValues(alpha: 0.2),
            onTap: () async {
              await setValue(SELECTED_LANGUAGE_CODE, data.languageCode);
              selectedLanguageDataModel = data;
              BaseLanguage temp = await const AppLocalizations().load(Locale(data.languageCode.validate()));
              locale = temp.obs;
              setValueToLocal(SELECTED_LANGUAGE_CODE, data.languageCode.validate());
              isRTL(Constants.rtlLanguage.contains(data.languageCode));
              selectedLanguageCode(data.languageCode.validate());
              Get.updateLocale(Locale(data.languageCode.validate()));
              settingController.settingList.clear();
              settingController.getInitListData();
              DashboardController dashboardController = Get.find();
              dashboardController.addDataOnBottomNav();
              getDashboardController().onBottomTabChange(0);
              HomeController homeController = Get.find();
              homeController.createCategorySections(homeController.dashboardDetail.value,true);
            },
          );
        },
        shrinkWrap: true,
        itemCount: localeLanguageList.length,
      ),
    );
  }
}
