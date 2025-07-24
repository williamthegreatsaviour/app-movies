import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/subscription/subscription_controller.dart';
import '../../../../utils/app_common.dart';
import '../../model/subscription_plan_model.dart';
import 'subscription_card.dart';

class SubscriptionListComponent extends StatelessWidget {
  final List<SubscriptionPlanModel> planList;

  final SubscriptionController subscriptionController;

  const SubscriptionListComponent({super.key, required this.planList, required this.subscriptionController});

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: planList.length,
      listAnimationType: commonListAnimationType,
      itemBuilder: (context, index) {
        return Obx(
          () => SubscriptionCard(
            planDet: planList[index],
            isSelected: subscriptionController.selectPlan.value.id == planList[index].id,
            revenueCatProduct: subscriptionController.getSelectedPlanFromRevenueCat(planList[index])?.storeProduct,
            onSelect: () {
              subscriptionController.selectPlan(planList[index]);
              subscriptionController.calculateTotalPrice();
              if (appConfigs.value.enableInAppPurchase.getBoolInt() && subscriptionController.getSelectedPlanFromRevenueCat(subscriptionController.selectPlan.value) != null) {
                subscriptionController.selectedRevenueCatPackage = subscriptionController.getSelectedPlanFromRevenueCat(subscriptionController.selectPlan.value)!.storeProduct;
              }
            },
          ).paddingBottom(16),
        );
      },
    );
  }
}
