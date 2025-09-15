import 'package:flutter/material.dart';

class ContractorView extends StatelessWidget {
  const ContractorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista del Contratista'),
      ),
      body: const Center(
        child: Text(
          'Bienvenido, Contratista',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}