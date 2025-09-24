import 'package:flutter/material.dart';
import 'worker.dart';

class WorkerDetailView extends StatelessWidget {
  final Worker worker;

  const WorkerDetailView({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB22222),
        title: Text(worker.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${worker.nombre}', style: const TextStyle(fontSize: 18, fontFamily: 'Inter')),
            Text('RUT: ${worker.rut}', style: const TextStyle(fontSize: 18, fontFamily: 'Inter')),
            Text('Puesto: ${worker.puesto}', style: const TextStyle(fontSize: 18, fontFamily: 'Inter')),
            Text('Horas: ${worker.horas}', style: const TextStyle(fontSize: 18, fontFamily: 'Inter')),
          ],
        ),
      ),
    );
  }
}
