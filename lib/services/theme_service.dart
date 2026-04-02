import 'package:flutter/material.dart';

import '../models/theme_model.dart';

class ThemeService {
  ThemeModel getThemeByLanguage(String languageCode) {
    return _themes[languageCode] ?? _themes['es']!;
  }

  static final Map<String, ThemeModel> _themes = {
    'sw': const ThemeModel(
      languageCode: 'sw',
      languageName: 'Swahili',
      backgroundImage:
          'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1400&q=80',
      primary: Color(0xFF8D5524),
      secondary: Color(0xFFD08C60),
      accent: Color(0xFFFFD54F),
      cardGradient: [Color(0xFFF0C27B), Color(0xFF4B1248)],
    ),
    'ja': const ThemeModel(
      languageCode: 'ja',
      languageName: 'Japanese',
      backgroundImage:
          'https://images.unsplash.com/photo-1528360983277-13d401cdc186?auto=format&fit=crop&w=1400&q=80',
      primary: Color(0xFF2D3142),
      secondary: Color(0xFFBFC0C0),
      accent: Color(0xFFF4ACB7),
      cardGradient: [Color(0xFFFAD0C4), Color(0xFFFFD1FF)],
    ),
    'fr': const ThemeModel(
      languageCode: 'fr',
      languageName: 'French',
      backgroundImage:
          'https://images.unsplash.com/photo-1431274172761-fca41d930114?auto=format&fit=crop&w=1400&q=80',
      primary: Color(0xFF1D3557),
      secondary: Color(0xFF457B9D),
      accent: Color(0xFFA8DADC),
      cardGradient: [Color(0xFFDAE2F8), Color(0xFFD6A4A4)],
    ),
    'de': const ThemeModel(
      languageCode: 'de',
      languageName: 'German',
      backgroundImage:
          'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?auto=format&fit=crop&w=1400&q=80',
      primary: Color(0xFF1B1B1E),
      secondary: Color(0xFF6D6A75),
      accent: Color(0xFFFFC857),
      cardGradient: [Color(0xFF434343), Color(0xFF000000)],
    ),
    'es': const ThemeModel(
      languageCode: 'es',
      languageName: 'Spanish',
      backgroundImage:
          'https://images.unsplash.com/photo-1520637836862-4d197d17c98a?auto=format&fit=crop&w=1400&q=80',
      primary: Color(0xFF7B2CBF),
      secondary: Color(0xFF9D4EDD),
      accent: Color(0xFFFFC300),
      cardGradient: [Color(0xFF6A11CB), Color(0xFF2575FC)],
    ),
  };
}
