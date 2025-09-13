import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    logger.d("Logger is working");

    return MaterialApp(
      title: 'Cherry Block',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}


