import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cherry_block/theme/util.dart';
import 'package:cherry_block/theme/theme.dart';
import 'package:cherry_block/provider/theme_provider.dart';
import 'pages/splash_screen.dart';
import 'pages/preferences_view.dart';
import 'provider/app_preferences_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final order = prefs.getString('order') ?? 'Recientes primero';
  final language = prefs.getString('language') ?? 'Español';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppPreferencesProvider()),
      ],
      child: const MyApp(),
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
