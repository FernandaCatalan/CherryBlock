import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider with ChangeNotifier {
  bool _modoOscuro = false;
  String _unidades = 'Kilos';
  String _ordenRegistros = 'Recientes primero';
  String _idioma = 'Español';

  bool get modoOscuro => _modoOscuro;
  String get unidades => _unidades;
  String get ordenRegistros => _ordenRegistros;
  String get idioma => _idioma;

  Future<void> cargarPreferencias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _modoOscuro = prefs.getBool('modoOscuro') ?? false;
    _unidades = prefs.getString('unidades') ?? 'Kilos';
    _ordenRegistros = prefs.getString('ordenRegistros') ?? 'Recientes primero';
    _idioma = prefs.getString('idioma') ?? 'Español';
    notifyListeners();
  }

  Future<void> setModoOscuro(bool valor) async {
    _modoOscuro = valor;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modoOscuro', valor);
    notifyListeners();
  }

  Future<void> setUnidades(String valor) async {
    _unidades = valor;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('unidades', valor);
    notifyListeners();
  }

  Future<void> setOrdenRegistros(String valor) async {
    _ordenRegistros = valor;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ordenRegistros', valor);
    notifyListeners();
  }

  Future<void> setIdioma(String valor) async {
    _idioma = valor;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('idioma', valor);
    notifyListeners();
  }
}
