import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/search/search_controller.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';

class SearchTextFieldComponent extends StatelessWidget {
  SearchTextFieldComponent({super.key});

  final SearchScreenController searchCont = Get.put(SearchScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppTextField(
        textStyle: primaryTextStyle(size: 14, ),
        controller: searchCont.searchCont,
        focus: searchCont.searchFocus,
        textFieldType: TextFieldType.NAME,
        cursorColor: white,
        decoration: inputDecorationWithFillBorder(
          context,
          fillColor: canvasColor,
          filled: true,
          hintText: locale.value.searchMoviesShowsAndMore,
          prefixIcon: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.search, size: 18, color: darkGrayColor),
          ),
          //
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              searchCont.isTyping.value
                  ? GestureDetector(
                      onTap: () {
                        searchCont.clearSearchField(context);
                      },
                      child: Icon(
                        Icons.clear,
                        size: 18,
                        color: appColorPrimary,
                      ),
                    )
                  : Offstage(),
              8.width,
              GestureDetector(
                onTap: () {
                  hideKeyboard(context);
                  if (!searchCont.isListening.value) {
                    searchCont.startListening();
                  } else {
                    searchCont.stopListening();
                  }
                },
                child: Icon(
                  searchCont.isListening.value ? Icons.keyboard_voice : Icons.keyboard_voice_outlined,
                  size: 18,
                  color: searchCont.isListening.value ? appColorPrimary : darkGrayColor,
                ),
              ),
              16.width,
            ],
          ),
        ),
        onChanged: (value) {
          searchCont.onSearch(searchVal: value.trim());
        },
        onFieldSubmitted: (value) {
          searchCont.onSearch(searchVal: value);
        },
      ),
    );
  }
}
