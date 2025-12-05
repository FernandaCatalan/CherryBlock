import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cherry_block/provider/theme_provider.dart';
import 'package:cherry_block/provider/app_preferences_provider.dart';
import 'package:cherry_block/pages/boss_view.dart';
import 'package:cherry_block/pages/contractor_view.dart';
import 'package:cherry_block/pages/cuadrilla_view.dart';
import 'package:cherry_block/pages/packing_view.dart';
import 'package:cherry_block/pages/planillero_view.dart';

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

  Future<void> goBackToRoleHome(BuildContext context) async {
    print("DEBUG: goBackToRoleHome() llamado");

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) { 
      print("DEBUG: No hay usuario logeado");
      return;
    }

    print("DEBUG: UID actual: ${user.uid}");

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (!doc.exists) {
      print("DEBUG: El documento del usuario NO existe en Firestore");
      return;
    }

    if (!doc.data()!.containsKey("role")) {
      print("DEBUG: El campo 'role' NO existe en Firestore");
      return;
    }

    final role = doc.get("role");
    print("DEBUG: Rol encontrado: $role");

    Widget target;

    switch (role) {
      case "dueño":
        target = const BossView();
        break;
      case "contratista":
        target = const ContractorView();
        break;
      case "jefe_cuadrilla":
        target = const CuadrillaView();
        break;
      case "jefe_packing":
        target = const PackingView();
        break;
      case "planillero":
        target = const PlanilleroView();
        break;

      default:
        print("DEBUG: Rol desconocido");
        return;
    }

    print("DEBUG: Navegando al Home del rol...");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => target),
      (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final appPrefs = Provider.of<AppPreferencesProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    print("DEBUG: Usuario actual en PreferencesView: $user");


    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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

          ListTile(
            leading: Icon(Icons.arrow_back, color: colorScheme.primary),
            title: Text(
              "Volver atrás",
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
