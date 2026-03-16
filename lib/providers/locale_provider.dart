import 'package:flutter/material.dart';

/// Manages the current locale/language selection for the app.
class LocaleProvider extends ChangeNotifier {
  String _languageCode = 'en'; // default English

  String get languageCode => _languageCode;
  String get languageName => _languageCode == 'de' ? 'Deutsch' : 'English';

  void setLanguage(String code) {
    if (code != _languageCode) {
      _languageCode = code;
      notifyListeners();
    }
  }
}
