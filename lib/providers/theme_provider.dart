import 'package:flutter/material.dart';

import '../models/theme_model.dart';
import '../services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(this._themeService) {
    _current = _themeService.getThemeByLanguage('es');
  }

  final ThemeService _themeService;
  late ThemeModel _current;

  ThemeModel get current => _current;

  void setLanguageTheme(String languageCode) {
    _current = _themeService.getThemeByLanguage(languageCode);
    notifyListeners();
  }
}
