import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cherry_block/provider/theme_provider.dart';

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
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      unit = prefs.getString('unit') ?? "kg";
    });
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('unit', unit);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Preferencias")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Modo oscuro"),
            value: themeProvider.isDark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
          ListTile(
            title: const Text("Unidad de medida"),
            trailing: DropdownButton<String>(
              value: unit,
              items: const [
                DropdownMenuItem(value: "kg", child: Text("Kilogramos")),
                DropdownMenuItem(value: "l", child: Text("Libras")),
              ],
              onChanged: (value) {
                setState(() => unit = value!);
                savePreferences();
              },
            ),
          ),
        ],
      ),
    );
  }
}
