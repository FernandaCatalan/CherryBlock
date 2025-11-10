import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesProvider with ChangeNotifier {
  String _order = 'Recientes primero';
  String _language = 'Español';

  String get order => _order;
  String get language => _language;

  AppPreferencesProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _order = prefs.getString('order') ?? 'Recientes primero';
    _language = prefs.getString('language') ?? 'Español';
    notifyListeners();
  }

  Future<void> setOrder(String value) async {
    _order = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('order', value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
    notifyListeners();
  }
}
