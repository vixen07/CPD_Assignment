

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingController extends GetxController {
   final controller = PageController(viewportFraction: 0.8, keepPage: true);
  final currentPage = 0.obs;
  final storage = GetStorage();
  final isLastPage = false.obs;

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void updatePageIndex(int index) {
    currentPage.value = index;
    isLastPage.value = index == 2; // Assuming 3 pages (0, 1, 2)
  }

  void nextPage() {
    if (isLastPage.value) {
      completeOnboarding();
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() {
    // Mark onboarding as completed in storage
    storage.write('onboarding_completed', true);
    // Navigate to the home screen or login screen
    Get.offAllNamed('/login');
  }
}