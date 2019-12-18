import 'package:flutter/material.dart';
import 'defined_localization.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class DefinedLocalizationDelegate
    extends LocalizationsDelegate<DefinedLocalizations> {
  const DefinedLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode); //增加语言也要在main.dart里面加
  }

  @override
  Future<DefinedLocalizations> load(Locale locale) {
    return new SynchronousFuture<DefinedLocalizations>(
        new DefinedLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<DefinedLocalizations> old) {
    return false;
  }

  static DefinedLocalizationDelegate delegate =
      const DefinedLocalizationDelegate();
}
