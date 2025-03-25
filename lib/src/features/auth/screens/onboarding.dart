import 'package:cpdassignment/src/features/auth/controllers/onboarding_controller.dart';
import 'package:cpdassignment/src/features/auth/widgets/build_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize and register the controller
    final controller = Get.put(OnboardingController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Skip button
            Positioned(
              top: 20.h,
              right: 20.w,
              child: Obx(() => controller.isLastPage.value
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: controller.skipOnboarding,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.sp,
                        ),
                      ),
                    )),
            ),
            
            // Page content
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndex,
              children: [
                OnboardingWidget(
                  image: 'assets/images/find_study_spot.png',
                  title: 'Find Perfect Study Spots',
                  description:
                      'Discover quiet libraries, cozy cafes, and dedicated study spaces near you. Filter by amenities, noise level, and more.',
                  backgroundColor: Colors.blue[50]!,
                ),
                OnboardingWidget(
                  image: 'assets/images/book_space.png',
                  title: 'Reserve Your Space',
                  description:
                      'Book study rooms and spaces in advance. Never worry about finding a place during exam season again.',
                  backgroundColor: Colors.green[50]!,
                ),
                OnboardingWidget(
                  image: 'assets/images/collaborate.png',
                  title: 'Connect With Study Buddies',
                  description:
                      'Find and join study groups in your area or create your own. Collaborate and learn together.',
                  backgroundColor: Colors.purple[50]!,
                ),
              ],
            ),
            
            // Bottom navigation area with indicator and button
            Positioned(
              bottom: 30.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Page indicator
                  Obx(() => SmoothPageIndicator(
                        controller: controller.pageController,
                        count: 3,
                        effect: WormEffect(
                          dotHeight: 10.h,
                          dotWidth: 10.w,
                          activeDotColor: Theme.of(context).primaryColor,
                          dotColor: Colors.grey.shade300,
                        ),
                      )),
                  SizedBox(height: 50.h),
                  
                  // Next/Get Started button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Obx(() => ElevatedButton(
                          onPressed: controller.nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            minimumSize: Size(double.infinity, 60.h),
                          ),
                          child: Text(
                            controller.isLastPage.value
                                ? 'Get Started'
                                : 'Next',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}