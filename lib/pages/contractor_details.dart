import 'package:flutter/material.dart';
import 'contractor.dart';

class ContractorDetailView extends StatelessWidget {
  final Contractor contractor;

  const ContractorDetailView({super.key, required this.contractor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB22222),
        title: Text(contractor.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${contractor.nombre}', style: const TextStyle(fontSize: 18, fontFamily: 'Inter')),
            Text('RUT: ${contractor.rut}', style: const TextStyle(fontSize: 18, fontFamily: 'Inter')),
            Text('Cantidad de personas: ${contractor.cantidadPersonas}', style: const TextStyle(fontSize: 18, fontFamily: 'Inter')),
          ],
        ),
      ),
    );
  }
}
