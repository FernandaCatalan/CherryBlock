import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cherry_block/services/theme_provider.dart';
import 'package:cherry_block/services/notification_service.dart'; 

class PreferencesView extends StatefulWidget {
  const PreferencesView({super.key});

  @override
  State<PreferencesView> createState() => _PreferencesViewState();
}

class _PreferencesViewState extends State<PreferencesView> {
  bool notifications = true;
  String unit = "kg";

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications = prefs.getBool('notifications') ?? true;
      unit = prefs.getString('unit') ?? "kg";
    });
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', notifications);
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
            title: const Text("Notificaciones"),
            value: notifications,
            onChanged: (value) async { 
              setState(() => notifications = value);
              await savePreferences(); 

              if (value) {
                Future.microtask(() => NotificationService.showNotification(
                      title: "Notificaciones activadas",
                      body: "Ahora recibirás alertas de Cherry Block 🍒",
                    ));
              } else {
                Future.microtask(() => NotificationService.showNotification(
                      title: "Notificaciones desactivadas",
                      body: "Has desactivado las alertas de Cherry Block.",
                    ));
              }
            },
          ),
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
                DropdownMenuItem(value: "l", child: Text("Litros")),
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
