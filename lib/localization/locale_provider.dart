import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US');
  Map<String, Map<String, String>> _translations = {};
  bool _isLoading = false;
  
  Locale get locale => _locale;
  bool get isRTL => _isRTL();
  String get currentLanguage => _locale.languageCode;
  bool get isLoading => _isLoading;
  
  // Supported languages with display names
  final Map<String, String> supportedLanguages = {
    'en': 'English',
    'ar': 'العربية',
    'fr': 'Français',
    'es': 'Español',
    'fa': 'فارسی',
    'ur': 'اردو',
  };
  
  // Language metadata
  final Map<String, Map<String, dynamic>> languageMetadata = {
    'en': {'direction': 'ltr', 'locale': 'en_US'},
    'ar': {'direction': 'rtl', 'locale': 'ar_SA'},
    'fr': {'direction': 'ltr', 'locale': 'fr_FR'},
    'es': {'direction': 'ltr', 'locale': 'es_ES'},
    'fa': {'direction': 'rtl', 'locale': 'fa_IR'},
    'ur': {'direction': 'rtl', 'locale': 'ur_PK'},
  };
  
  LocaleProvider() {
    _loadSavedLocale();
  }
  
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('app_language');
    
    if (languageCode != null && supportedLanguages.containsKey(languageCode)) {
      final countryCode = _getCountryCode(languageCode);
      _locale = Locale(languageCode, countryCode);
      await _loadTranslations(languageCode);
    }
    
    notifyListeners();
  }
  
  Future<void> setLocale(Locale newLocale) async {
    if (!supportedLanguages.containsKey(newLocale.languageCode)) {
      return;
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', newLocale.languageCode);
      
      // Load translations
      await _loadTranslations(newLocale.languageCode);
      
      // Update locale
      final countryCode = _getCountryCode(newLocale.languageCode);
      _locale = Locale(newLocale.languageCode, countryCode);
      
      // Clear loading state
      _isLoading = false;
      notifyListeners();
      
      // Optional: Notify system for locale-aware operations
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  Future<void> _loadTranslations(String languageCode) async {
    // Check if already loaded
    if (_translations.containsKey(languageCode)) {
      return;
    }
    
    try {
      // Load from assets
      final translations = await _loadAssetTranslations(languageCode);
      _translations[languageCode] = translations;
    } catch (e) {
      // Fallback to English
      if (languageCode != 'en') {
        final englishTranslations = await _loadAssetTranslations('en');
        _translations[languageCode] = englishTranslations;
      }
    }
  }
  
  Future<Map<String, String>> _loadAssetTranslations(String languageCode) async {
    final path = 'assets/translations/$languageCode.json';
    
    try {
      final jsonString = await DefaultAssetBundle.of(navigatorKey.currentContext!)
          .loadString(path);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return jsonMap.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      // Return empty map if file doesn't exist
      return {};
    }
  }
  
  Future<void> syncWithAdminPanel({
    required String adminUrl,
    required String apiKey,
  }) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await http.get(
        Uri.parse('$adminUrl/api/languages'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Accept-Language': currentLanguage,
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _processAdminLanguages(data);
      }
    } catch (e) {
      // Handle error silently or log it
      print('Failed to sync with admin panel: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> _processAdminLanguages(Map<String, dynamic> data) async {
    final List<dynamic> languages = data['languages'] ?? [];
    final prefs = await SharedPreferences.getInstance();
    
    for (final lang in languages) {
      final code = lang['code'];
      final name = lang['name'];
      final isActive = lang['is_active'] ?? false;
      
      if (isActive && !supportedLanguages.containsKey(code)) {
        supportedLanguages[code] = name;
        languageMetadata[code] = {
          'direction': lang['direction'] ?? 'ltr',
          'locale': lang['locale'] ?? code,
        };
      }
    }
    
    // Save updated languages
    await prefs.setString('supported_languages', json.encode(supportedLanguages));
    notifyListeners();
  }
  
  String _getCountryCode(String languageCode) {
    final metadata = languageMetadata[languageCode];
    if (metadata != null && metadata['locale'] != null) {
      final localeParts = metadata['locale'].toString().split('_');
      return localeParts.length > 1 ? localeParts[1] : '';
    }
    return '';
  }
  
  bool _isRTL() {
    final metadata = languageMetadata[_locale.languageCode];
    return metadata != null && metadata['direction'] == 'rtl';
  }
  
  TextDirection get textDirection {
    return isRTL ? TextDirection.rtl : TextDirection.ltr;
  }
  
  Alignment get alignmentStart {
    return isRTL ? Alignment.centerRight : Alignment.centerLeft;
  }
  
  Alignment get alignmentEnd {
    return isRTL ? Alignment.centerLeft : Alignment.centerRight;
  }
  
  CrossAxisAlignment get crossAxisAlignmentStart {
    return isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  }
  
  CrossAxisAlignment get crossAxisAlignmentEnd {
    return isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end;
  }
  
  // Helper method to format numbers based on locale
  String formatNumber(num value) {
    final formatter = NumberFormat.decimalPattern(_locale.toString());
    return formatter.format(value);
  }
  
  // Helper method to format currency based on locale
  String formatCurrency(num value, {String? currencySymbol}) {
    final formatter = NumberFormat.currency(
      locale: _locale.toString(),
      symbol: currencySymbol,
    );
    return formatter.format(value);
  }
  
  // Helper method to format date based on locale
  String formatDate(DateTime date, {String? format}) {
    final formatter = format != null
        ? DateFormat(format, _locale.toString())
        : DateFormat.yMMMMd(_locale.toString());
    return formatter.format(date);
  }
}
