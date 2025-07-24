import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/payment/model/payment_model.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../payment_controller.dart';

class PaymentCardComponent extends StatelessWidget {
  final PaymentSetting paymentDetails;

  PaymentCardComponent({super.key, required this.paymentDetails});

  final PaymentController paymentCont = Get.find<PaymentController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          paymentCont.selectPayment(paymentDetails);
          paymentCont.paymentOption.value = paymentDetails.type.validate();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: boxDecorationDefault(
            borderRadius: BorderRadius.circular(6),
            color: canvasColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                paymentDetails.title.validate(),
                style: secondaryTextStyle(
                  size: 14,
                  color: white,
                  weight: FontWeight.w500,
                ),
              ).expand(),
              if (paymentDetails.id == paymentCont.selectPayment.value.id)
                const Icon(
                  Icons.radio_button_checked_rounded,
                  size: 18,
                  color: appColorPrimary,
                )
              else
                const Icon(
                  Icons.radio_button_off_rounded,
                  size: 18,
                  color: darkGrayColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
