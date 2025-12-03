import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'provider/auth_provider.dart';

import 'package:cherry_block/theme/util.dart';
import 'package:cherry_block/theme/theme.dart';
import 'package:cherry_block/provider/theme_provider.dart';
import 'provider/app_preferences_provider.dart';

import 'pages/splash_screen.dart';
import 'pages/login_screen.dart';

import 'pages/boss_view.dart';
import 'pages/contractor_view.dart';
import 'pages/cuadrilla_view.dart';
import 'pages/packing_view.dart';
import 'pages/planillero_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final order = prefs.getString('order') ?? 'Recientes primero';
  final language = prefs.getString('language') ?? 'Español';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppPreferencesProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()), 
      ],
      child: MyApp(
        initialOrder: order,
        initialLanguage: language,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String initialOrder;
  final String initialLanguage;

  const MyApp({
    super.key,
    this.initialOrder = 'Recientes primero',
    this.initialLanguage = 'Español',
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late Brightness brightness;
  late MaterialTheme theme;
  late TextTheme textTheme;

  late String order;
  late String language;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

    order = widget.initialOrder;
    language = widget.initialLanguage;
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    logger.d("Logger is working");

    final themeProvider = Provider.of<ThemeProvider>(context);

    textTheme = createTextTheme(context, "Inter", "Inter");
    theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Cherry Block',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      theme: theme.light(),
      darkTheme: theme.dark(),
      home: const SplashScreen(),
    );
  }
}

class RoleRouter extends StatelessWidget {
  const RoleRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (!auth.isAuthenticated) {
      return const SplashScreen();
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(auth.user!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const LoginScreen();
        }

        final role = snapshot.data!.get('rol') ?? 'none';

        switch (role) {
          case 'dueño':
            return const BossView();
          case 'jefe_cuadrilla':
            return const CuadrillaView();
          case 'jefe_packing':
            return const PackingView();
          case 'contratista':
            return const ContractorView();
          case 'planillero':
            return const PlanilleroView();
          default:
            return const LoginScreen();
        }
      },
    );
  }
}

