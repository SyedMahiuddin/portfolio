import 'package:flutter/material.dart';

class ThemeModel {
  final String id;
  final String name;
  final String description;
  final ThemeStyle style;
  final Map<String, Color> colors;

  ThemeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.style,
    required this.colors,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    Map<String, Color> colorMap = {};
    if (json['colors'] != null) {
      (json['colors'] as Map<String, dynamic>).forEach((key, value) {
        colorMap[key] = Color(int.parse(value.toString()));
      });
    }

    return ThemeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      style: ThemeStyle.values.firstWhere(
            (e) => e.toString() == 'ThemeStyle.${json['style']}',
        orElse: () => ThemeStyle.glassmorphism,
      ),
      colors: colorMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'style': style.toString().split('.').last,
      'colors': colors.map((key, value) => MapEntry(key, value.value)),
    };
  }
}

enum ThemeStyle {
  glassmorphism,
  neumorphism,
  gradient,
  minimal,
  cyberpunk,
}

class ThemeColorScheme {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color text;

  ThemeColorScheme({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.text,
  });

  Map<String, Color> toMap() {
    return {
      'primary': primary,
      'secondary': secondary,
      'accent': accent,
      'background': background,
      'surface': surface,
      'text': text,
    };
  }

  factory ThemeColorScheme.fromMap(Map<String, Color> map) {
    return ThemeColorScheme(
      primary: map['primary'] ?? Color(0xFFB24BF3),
      secondary: map['secondary'] ?? Color(0xFF00E5FF),
      accent: map['accent'] ?? Color(0xFFFF006B),
      background: map['background'] ?? Color(0xFF0A0E27),
      surface: map['surface'] ?? Color(0xFF1a1f3a),
      text: map['text'] ?? Color(0xFFFFFFFF),
    );
  }
}