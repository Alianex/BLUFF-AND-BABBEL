import 'package:flutter/material.dart';

class ThemeModel {
  const ThemeModel({
    required this.languageCode,
    required this.languageName,
    required this.backgroundImage,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.cardGradient,
  });

  final String languageCode;
  final String languageName;
  final String backgroundImage;
  final Color primary;
  final Color secondary;
  final Color accent;
  final List<Color> cardGradient;
}
