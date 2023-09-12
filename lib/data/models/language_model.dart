// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LanguageModel extends Equatable {
  final String langCode;
  final String countryCode;
  final String languageName;
  late final Locale locale;

  LanguageModel(
      {required this.langCode,
      required this.countryCode,
      required this.languageName}) {
    locale = Locale(langCode, countryCode);
  }

  @override
  List<Object?> get props => [langCode, countryCode];
}

LanguageModel ArabicLanguage =
    LanguageModel(langCode: 'ar', countryCode: 'AR', languageName: 'arabic');
LanguageModel EnglishLanguage =
    LanguageModel(langCode: 'en', countryCode: 'EN', languageName: 'english');
