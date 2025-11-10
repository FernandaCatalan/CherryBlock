import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:cherry_block/pages/home.dart';

void main() {
  runApp(const CherryBlockApp());
}

class CherryBlockApp extends StatelessWidget {
  const CherryBlockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cherry Block',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, 
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFB22222),
          onPrimary: Colors.white,
          surface: Color(0xFFF5E9DA),
          onSurface: Colors.black,
          secondary: Color(0xFF8B1A1A),
        ),
        textTheme: GoogleFonts.interTextTheme().copyWith(
          bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.bold),
          bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF6F91), 
          onPrimary: Colors.white,
          surface: Color(0xFF1E1E1E),
          onSurface: Color(0xFFF5E9DA),
          secondary: Color(0xFFFFB3C6),
        ),
        textTheme: GoogleFonts.interTextTheme().copyWith(
          bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.bold),
          bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 6));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    Timer(const Duration(seconds: 6), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(title: 'Cherry Block'),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.4,
                height: size.width * 0.4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Logo.webp'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Cherry Block',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: size.width * 0.08,
                ),
              ),
              const SizedBox(height: 10),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
