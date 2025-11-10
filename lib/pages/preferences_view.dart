import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cherry_block/provider/theme_provider.dart';
import 'package:cherry_block/provider/app_preferences_provider.dart';

class PreferencesView extends StatefulWidget {
  const PreferencesView({super.key});

  @override
  State<PreferencesView> createState() => _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {
  String unit = "kg";

  @override
  void initState() {
    super.initState();
    loadUnitPreference();
  }

  Future<void> loadUnitPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      unit = prefs.getString('unit') ?? "kg";
    });
  }

  Future<void> saveUnitPreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('unit', value);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appPrefs = Provider.of<AppPreferencesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appPrefs.language == "Español" ? "Preferencias" : "Preferences"),
      ),
      body: ListView(
        children: [
          // Modo oscuro
          SwitchListTile(
            title: Text(appPrefs.language == "Español" ? "Modo oscuro" : "Dark Mode"),
            value: themeProvider.isDark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),

          // Unidad de medida
          ListTile(
            title: Text(appPrefs.language == "Español" ? "Unidad de medida" : "Unit"),
            trailing: DropdownButton<String>(
              value: unit,
              items: const [
                DropdownMenuItem(value: "kg", child: Text("Kilogramos")),
                DropdownMenuItem(value: "l", child: Text("Libras")),
              ],
              onChanged: (value) {
                setState(() => unit = value!);
                saveUnitPreference(unit);
              },
            ),
          ),

          // Orden de registros
          ListTile(
            title: Text(appPrefs.language == "Español" ? "Orden de registros" : "Record Order"),
            trailing: DropdownButton<String>(
              value: appPrefs.order,
              items: const [
                DropdownMenuItem(value: "Recientes primero", child: Text("Recientes primero")),
                DropdownMenuItem(value: "Antiguos primero", child: Text("Antiguos primero")),
              ],
              onChanged: (value) {
                if (value != null) appPrefs.setOrder(value);
              },
            ),
          ),

          // Idioma
          ListTile(
            title: Text(appPrefs.language == "Español" ? "Idioma" : "Language"),
            trailing: DropdownButton<String>(
              value: appPrefs.language,
              items: const [
                DropdownMenuItem(value: "Español", child: Text("Español")),
                DropdownMenuItem(value: "Inglés", child: Text("Inglés")),
              ],
              onChanged: (value) {
                if (value != null) appPrefs.setLanguage(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
