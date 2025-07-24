// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatingController extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  RxBool isExpanded = false.obs;

  @override
  void onInit() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    super.onInit();
  }

  void toggle() {
    isExpanded.value = !isExpanded.value;
    if (isExpanded.isTrue) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void closeToggle() {
    isExpanded(false);
    _controller.reverse();
  }

  @override
  void onClose() {
    // _controller.dispose();
    super.onClose();
  }
}
