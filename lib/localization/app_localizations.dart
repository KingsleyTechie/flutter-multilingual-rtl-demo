import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
  
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
    Locale('fr', 'FR'),
    Locale('es', 'ES'),
    Locale('fa', 'IR'),
    Locale('ur', 'PK'),
  ];
  
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
  
  Map<String, String>? _localizedStrings;
  
  Future<bool> load() async {
    String jsonString;
    
    switch (locale.languageCode) {
      case 'ar':
        jsonString = await _loadAsset('localization/arb/app_ar.arb');
        break;
      case 'fr':
        jsonString = await _loadAsset('localization/arb/app_fr.arb');
        break;
      case 'es':
        jsonString = await _loadAsset('localization/arb/app_es.arb');
        break;
      case 'fa':
        jsonString = await _loadAsset('localization/arb/app_fa.arb');
        break;
      case 'ur':
        jsonString = await _loadAsset('localization/arb/app_ur.arb');
        break;
      default:
        jsonString = await _loadAsset('localization/arb/app_en.arb');
    }
    
    _localizedStrings = _parseARB(jsonString);
    return true;
  }
  
  Future<String> _loadAsset(String path) async {
    return await DefaultAssetBundle.of(navigatorKey.currentContext!).loadString(path);
  }
  
  Map<String, String> _parseARB(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final Map<String, String> localizedStrings = {};
    
    jsonMap.forEach((key, value) {
      if (!key.startsWith('@') && value is String) {
        localizedStrings[key] = value;
      }
    });
    
    return localizedStrings;
  }
  
  String translate(String key) {
    if (_localizedStrings == null) {
      return key;
    }
    
    // Try exact match
    if (_localizedStrings!.containsKey(key)) {
      return _localizedStrings![key]!;
    }
    
    // Try case-insensitive match
    final lowerKey = key.toLowerCase();
    for (final entry in _localizedStrings!.entries) {
      if (entry.key.toLowerCase() == lowerKey) {
        return entry.value;
      }
    }
    
    // Fallback to English
    if (locale.languageCode != 'en') {
      // In production, you would load English fallback here
    }
    
    return key;
  }
  
  String translateWithParams(String key, Map<String, dynamic> params) {
    String translation = translate(key);
    
    params.forEach((paramKey, paramValue) {
      translation = translation.replaceAll('{$paramKey}', paramValue.toString());
    });
    
    return translation;
  }
  
  // Helper method for context extension
  static String translateString(BuildContext context, String key) {
    return of(context)?.translate(key) ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supportedLocale) => supportedLocale.languageCode == locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }
  
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// Extension for easier access
extension LocalizationExtension on BuildContext {
  String translate(String key) {
    return AppLocalizations.of(this)?.translate(key) ?? key;
  }
  
  String translateWithParams(String key, Map<String, dynamic> params) {
    return AppLocalizations.of(this)?.translateWithParams(key, params) ?? key;
  }
  
  bool get isRTL {
    final locale = Localizations.localeOf(this);
    return locale.languageCode == 'ar' ||
           locale.languageCode == 'fa' ||
           locale.languageCode == 'he' ||
           locale.languageCode == 'ur';
  }
}

// Global navigator key for accessing context in async operations
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
