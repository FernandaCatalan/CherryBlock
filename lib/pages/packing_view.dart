import 'package:flutter/material.dart';

class PackingView extends StatelessWidget {
  const PackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista del Jefe de Packing'),
      ),
      body: const Center(
        child: Text(
          'Bienvenido, Jefe de Packing',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}