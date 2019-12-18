import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FullbackCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FullbackCupertinoLocalizationsDelegate();

  bool isSupported(Locale locale) => true;

  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  bool shouldReload(FullbackCupertinoLocalizationsDelegate old) => false;
}
