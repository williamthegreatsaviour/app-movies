import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'components/form_fields_component.dart';
import 'components/profile_photo_component.dart';
import 'edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final EditProfileController profileCont = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: profileCont.isLoading,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBartitleText: locale.value.editProfile,
      body: AnimatedScrollView(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfilePicComponent(),
          EditFormFieldComponent(),
        ],
      ).paddingAll(16),
    );
  }
}
