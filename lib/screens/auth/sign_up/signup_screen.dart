import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/extension/date_time_extention.dart';
import 'package:streamit_laravel/utils/extension/string_extention.dart';

import '../../../components/cached_image_widget.dart';
import '../../../utils/common_base.dart';
import '../../../utils/country_picker/country_list.dart';
import '../../../utils/country_picker/country_utils.dart';
import 'sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController signUpController = Get.put(SignUpController());

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      scaffoldBackgroundColor: appScreenBackgroundDark,
      isLoading: signUpController.isLoading,
      topBarBgColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 120),
        child: Form(
          key: signUpController.signUpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CachedImageWidget(
                url: Assets.assetsAppLogo,
                height: 41,
              ).center(),
              40.height,
              Text(locale.value.createYourAccount, style: boldTextStyle(size: 20)),
              8.height,
              Text(locale.value.completeProfileSubtitle, style: secondaryTextStyle()),
              28.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            signUpController.changeCountry(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: boxDecorationDefault(
                              borderRadius: BorderRadiusDirectional.zero,
                              border: Border(bottom: BorderSide(color: borderColor.withValues(alpha: 0.6))),
                              color: appScreenBackgroundDark,
                            ),
                            child: Row(
                              children: [
                                Text(signUpController.selectedCountry.value.flagEmoji, style: primaryTextStyle(size: 20)),
                                6.width,
                                Text(signUpController.countryCode.value, style: primaryTextStyle()),
                                6.width,
                                const Icon(Icons.arrow_drop_down, color: iconColor)
                              ],
                            ),
                          ),
                        ),
                        16.width,
                        AppTextField(
                          textStyle: primaryTextStyle(),
                          controller: signUpController.mobileCont,
                          textFieldType: TextFieldType.PHONE,
                          cursorColor: white,
                          nextFocus: signUpController.firstNameFocus,
                          maxLength: getValidPhoneNumberLength(CountryModel.fromJson(signUpController.selectedCountry.value.toJson())),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (mobileCont) {
                            if (mobileCont!.isEmpty) {
                              return locale.value.phnRequiredText;
                            }
                            return null;
                          },
                          decoration: inputDecoration(
                            context,
                            contentPadding: const EdgeInsets.only(top: 14),
                            hintText: locale.value.mobileNumber,
                            prefixIcon: Image.asset(
                              Assets.iconsIcPhone,
                              color: iconColor,
                              height: 12,
                              width: 12,
                            ).paddingAll(14),
                          ),
                          onChanged: (value) {
                            signUpController.onBtnEnable();
                          },
                        ).expand(flex: 3)
                      ],
                    ),
                  ),
                  16.height,
                  AppTextField(
                    textStyle: primaryTextStyle(),
                    controller: signUpController.firstNameCont,
                    focus: signUpController.firstNameFocus,
                    nextFocus: signUpController.lastNameFocus,
                    textFieldType: TextFieldType.NAME,
                    cursorColor: white,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return locale.value.firstNameIsRequiredField;
                      }
                      return null;
                    },
                    decoration: inputDecoration(
                      context,
                      contentPadding: const EdgeInsets.only(top: 15),
                      hintText: locale.value.firstName,
                      prefixIcon: Image.asset(
                        Assets.iconsIcDefaultUser,
                        color: iconColor,
                        height: 12,
                        width: 12,
                      ).paddingAll(14),
                    ),
                    onChanged: (value) {
                      signUpController.onBtnEnable();
                    },
                  ),
                  16.height,
                  AppTextField(
                    textStyle: primaryTextStyle(),
                    controller: signUpController.lastNameCont,
                    focus: signUpController.lastNameFocus,
                    nextFocus: signUpController.emailFocus,
                    textFieldType: TextFieldType.NAME,
                    cursorColor: white,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return locale.value.lastNameIsRequiredField;
                      }
                      return null;
                    },
                    decoration: inputDecoration(
                      context,
                      contentPadding: const EdgeInsets.only(top: 15),
                      hintText: locale.value.lastName,
                      prefixIcon: Image.asset(
                        Assets.iconsIcDefaultUser,
                        color: iconColor,
                        height: 12,
                        width: 12,
                      ).paddingAll(14),
                    ),
                    onChanged: (value) {
                      signUpController.onBtnEnable();
                    },
                  ),
                  16.height,
                  AppTextField(
                    textStyle: primaryTextStyle(size: 12, color: white),
                    controller: signUpController.dobCont,
                    focus: signUpController.dobFocus,
                    textFieldType: TextFieldType.OTHER,
                    readOnly: true,
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: signUpController.dobCont.text.isNotEmpty ? DateTime.parse(signUpController.dobCont.text) : null,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          confirmText: locale.value.ok,
                          cancelText: locale.value.cancel,
                          helpText: locale.value.dateOfBirth,
                          locale: Locale(selectedLanguageDataModel?.languageCode ?? getStringAsync(SELECTED_LANGUAGE_CODE)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.dark(brightness: Brightness.dark, surface: cardColor, surfaceTint: cardColor, primary: appColorPrimary, onPrimary: primaryTextColor),
                                hintColor: secondaryTextColor,
                                inputDecorationTheme: const InputDecorationTheme(
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                                  hintStyle: TextStyle(fontSize: 16, color: Colors.white),
                                  fillColor: appColorPrimary,
                                ),
                              ),
                              child: child!,
                            );
                          });
                      if (selectedDate != null) {
                        signUpController.dobCont.text = selectedDate.formatDateYYYYmmdd();
                      } else {
                        log("Date is not selected");
                      }
                    },
                    decoration: inputDecoration(
                      context,
                      contentPadding: const EdgeInsets.only(top: 14),
                      hintText: locale.value.dateOfBirth,
                      prefixIcon: Image.asset(
                        Assets.iconsIcBirthdate,
                        color: iconColor,
                        height: 12,
                        width: 12,
                      ).paddingAll(17),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return locale.value.birthdayIsRequired;
                      }
                      return null;
                    },
                  ),
                  16.height,
                  Obx(() {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Gender:",
                          style: primaryTextStyle(),
                        ),
                        16.width,
                        Text(
                          "Male",
                          style: secondaryTextStyle(),
                        ),
                        Radio(
                            value: Gender.male,
                            groupValue: signUpController.selectedGender.value,
                            onChanged: (value) {
                              signUpController.setGender(value!);
                            }),
                        Text(
                          "Female",
                          style: secondaryTextStyle(),
                        ),
                        Radio(
                            value: Gender.female,
                            groupValue: signUpController.selectedGender.value,
                            onChanged: (value) {
                              signUpController.setGender(value!);
                            }),
                        Text(
                          "Other",
                          style: secondaryTextStyle(),
                        ),
                        Radio(
                            value: Gender.other,
                            groupValue: signUpController.selectedGender.value,
                            onChanged: (value) {
                              signUpController.setGender(value!);
                            }),
                      ],
                    ).paddingSymmetric(horizontal: 16);
                  }),
                  16.height,
                  AppTextField(
                    textStyle: primaryTextStyle(),
                    controller: signUpController.emailCont,
                    focus: signUpController.emailFocus,
                    nextFocus: signUpController.passwordFocus,
                    textFieldType: TextFieldType.EMAIL_ENHANCED,
                    cursorColor: white,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return locale.value.emailIsARequiredField;
                      } else if (!value.isValidEmail()) {
                        return locale.value.pleaseEnterValidEmailAddress;
                      }
                      return null;
                    },
                    decoration: inputDecoration(
                      context,
                      contentPadding: const EdgeInsets.only(top: 15),
                      hintText: locale.value.email,
                      prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcEmail, color: secondaryTextColor, size: 12).paddingAll(14),
                    ),
                    onChanged: (value) {
                      signUpController.onBtnEnable();
                    },
                  ),
                  16.height,
                  AppTextField(
                    textStyle: primaryTextStyle(color: white),
                    controller: signUpController.passwordCont,
                    focus: signUpController.passwordFocus,
                    nextFocus: signUpController.confPasswordFocus,
                    obscureText: true,
                    textFieldType: TextFieldType.PASSWORD,
                    cursorColor: white,
                    isValidationRequired: true,
                    errorThisFieldRequired: locale.value.passwordIsRequiredField,
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.password,
                      contentPadding: const EdgeInsets.only(top: 14),
                      prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcLockKey, color: iconColor, size: 12).paddingAll(16),
                    ),
                    suffixPasswordVisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEye, color: iconColor, size: 12).paddingAll(16),
                    suffixPasswordInvisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, color: iconColor, size: 12).paddingAll(16),
                    onChanged: (value) {
                      signUpController.onBtnEnable();
                    },
                  ),
                  16.height,
                  AppTextField(
                    textStyle: primaryTextStyle(color: white),
                    controller: signUpController.confPasswordCont,
                    focus: signUpController.confPasswordFocus,
                    nextFocus: signUpController.dobFocus,
                    obscureText: true,
                    textFieldType: TextFieldType.PASSWORD,
                    cursorColor: white,
                    isValidationRequired: true,
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.confirmPassword,
                      contentPadding: const EdgeInsets.only(top: 14),
                      prefixIcon: commonLeadingWid(imgPath: Assets.iconsIcLockKey, color: iconColor, size: 12).paddingAll(16),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return locale.value.passwordIsRequiredField;
                      return signUpController.passwordCont.text == value ? null : locale.value.yourConfirmPasswordDoesnT;
                    },
                    suffixPasswordVisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEye, color: iconColor, size: 12).paddingAll(16),
                    suffixPasswordInvisibleWidget: commonLeadingWid(imgPath: Assets.iconsIcEyeSlash, color: iconColor, size: 12).paddingAll(16),
                    onChanged: (value) {
                      signUpController.onBtnEnable();
                    },
                  ),
                  40.height,
                  AppButton(
                    width: double.infinity,
                    text: locale.value.signUp,
                    color: appColorPrimary,
                    textStyle: appButtonTextStyleWhite,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                    onTap: () {
                      if (signUpController.signUpFormKey.currentState!.validate()) {
                        hideKeyboard(context);
                        signUpController.saveForm();
                      }
                    },
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 24),
        ),
      ),
    );
  }
}
