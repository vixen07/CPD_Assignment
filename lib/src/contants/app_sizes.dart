import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Helper class for responsive UI elements
class AppSizes {
  // Text sizes
  static double get headline1 => 26.sp;
  static double get headline2 => 22.sp;
  static double get headline3 => 18.sp;
  static double get bodyText1 => 16.sp;
  static double get bodyText2 => 14.sp;
  static double get caption => 12.sp;
  
  // Padding and margins
  static double get smallPadding => 8.w;
  static double get mediumPadding => 16.w;
  static double get largePadding => 24.w;
  
  // Border radius
  static double get smallRadius => 4.r;
  static double get mediumRadius => 8.r;
  static double get largeRadius => 16.r;
  
  // Icon sizes
  static double get smallIcon => 18.sp;
  static double get mediumIcon => 24.sp;
  static double get largeIcon => 32.sp;
  
  // Screen size helpers
  static double get screenWidth => 1.sw;
  static double get screenHeight => 1.sh;
  static double get halfScreenWidth => 0.5.sw;
  static double get halfScreenHeight => 0.5.sh;
  
  // Responsive width and height
  static double width(double size) => size.w;
  static double height(double size) => size.h;
  static double radius(double size) => size.r;
  static double fontSize(double size) => size.sp;
}