import 'package:flutter/material.dart';

class CuadrillaView extends StatelessWidget {
  const CuadrillaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista del Jefe de Cuadrilla'),
      ),
      body: const Center(
        child: Text(
          'Bienvenido, Jefe de Cuadrilla',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}