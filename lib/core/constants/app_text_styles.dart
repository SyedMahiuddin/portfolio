import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_colors.dart';

class AppTextStyles {
  static double _getResponsiveFontSize(double baseFontSize) {
    final width = Get.width;
    if (width < 600) {
      return baseFontSize * 0.6;
    } else if (width < 1024) {
      return baseFontSize * 0.75;
    } else if (width < 1440) {
      return baseFontSize * 0.9;
    }
    return baseFontSize;
  }

  static TextStyle get headline1 => TextStyle(
    fontSize: _getResponsiveFontSize(64),
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    height: 1.2,
  );

  static TextStyle get headline2 => TextStyle(
    fontSize: _getResponsiveFontSize(48),
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle get headline3 => TextStyle(
    fontSize: _getResponsiveFontSize(32),
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle get body1 => TextStyle(
    fontSize: _getResponsiveFontSize(18),
    color: Colors.white70,
    height: 1.6,
  );

  static TextStyle get body2 => TextStyle(
    fontSize: _getResponsiveFontSize(16),
    color: Colors.white60,
    height: 1.5,
  );

  static TextStyle get button => TextStyle(
    fontSize: _getResponsiveFontSize(16),
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}