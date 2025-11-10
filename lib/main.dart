import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    logger.d("Logger is working");

    return MaterialApp(
      title: 'Cherry Block',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: const Color(0xFFB22222), 
        scaffoldBackgroundColor: const Color(0xFFF5E9DA), 
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5C4033), 
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFAFAFA),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}


