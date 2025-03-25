import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  final storage = GetStorage();
  final isLastPage = false.obs;

  @override
  void onClose() {
    pageController.dispose();
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
      pageController.nextPage(
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