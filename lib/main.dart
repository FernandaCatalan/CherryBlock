import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:cherry_block/theme/util.dart';
import 'package:cherry_block/theme/theme.dart';
import 'package:cherry_block/provider/theme_provider.dart';
import 'pages/splash_screen.dart';
import 'pages/preferences_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late Brightness brightness;
  late MaterialTheme theme;
  late TextTheme textTheme;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
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
