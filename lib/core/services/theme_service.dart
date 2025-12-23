import 'dart:ui';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/theme_model.dart';

class ThemeService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<ThemeModel?> currentTheme = Rx<ThemeModel?>(null);
  final Rx<ThemeColorScheme> colorScheme = Rx<ThemeColorScheme>(
    ThemeColorScheme.fromMap({}),
  );

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  Future<void> loadTheme() async {
    try {
      final doc = await _firestore.collection('settings').doc('theme').get();
      if (doc.exists) {
        currentTheme.value = ThemeModel.fromJson(doc.data()!);
        colorScheme.value = ThemeColorScheme.fromMap(currentTheme.value!.colors);
      }
    } catch (e) {
      print('Error loading theme: $e');
    }
  }

  Future<void> saveTheme(ThemeModel theme) async {
    try {
      await _firestore.collection('settings').doc('theme').set(theme.toJson());
      currentTheme.value = theme;
      colorScheme.value = ThemeColorScheme.fromMap(theme.colors);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  Future<void> updateColors(Map<String, Color> colors) async {
    if (currentTheme.value != null) {
      final updatedTheme = ThemeModel(
        id: currentTheme.value!.id,
        name: currentTheme.value!.name,
        description: currentTheme.value!.description,
        style: currentTheme.value!.style,
        colors: colors,
      );
      await saveTheme(updatedTheme);
    }
  }
}