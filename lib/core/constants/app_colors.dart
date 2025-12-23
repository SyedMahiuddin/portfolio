import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/theme_service.dart';

class AppColors {
  static Color get background {
    final themeService = Get.find<ThemeService>();
    return themeService.colorScheme.value.background;
  }

  static Color get purple {
    final themeService = Get.find<ThemeService>();
    return themeService.colorScheme.value.primary;
  }

  static Color get cyan {
    final themeService = Get.find<ThemeService>();
    return themeService.colorScheme.value.secondary;
  }

  static Color get pink {
    final themeService = Get.find<ThemeService>();
    return themeService.colorScheme.value.accent;
  }

  static const white = Color(0xFFFFFFFF);

  static Color get glassBackground {
    final themeService = Get.find<ThemeService>();
    return themeService.colorScheme.value.surface.withOpacity(0.05);
  }

  static Color get glassBorder {
    return white.withOpacity(0.2);
  }

  static List<Color> get gradientColors {
    final themeService = Get.find<ThemeService>();
    return [
      themeService.colorScheme.value.primary,
      themeService.colorScheme.value.accent,
      themeService.colorScheme.value.secondary,
    ];
  }
}