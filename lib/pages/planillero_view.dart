import 'package:flutter/material.dart';

class PlanilleroView extends StatelessWidget {
  const PlanilleroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista del Planillero'),
      ),
      body: const Center(
        child: Text(
          'Bienvenido, Planillero',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}