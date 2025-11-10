import 'package:flutter/material.dart';
import 'feedback.dart';

class AcercaView extends StatelessWidget {
  const AcercaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB22222),
        title: const Text('Acerca de'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CHERRY BLOCK',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB22222),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Desarrolladora: Fernanda Catalán',
              style: TextStyle(fontSize: 18, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Contacto: fernanda.catalan.contact@gmail.com',
              style: TextStyle(fontSize: 18, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Descripción:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 5),
            const Text(
              'Cherry block es una aplicación para la gestión de actividades en un fundo.',
              style: TextStyle(fontSize: 16, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => FeedbackPage())
              );
              },
              child: const Text('Valorar la App'),
            ),
          ],
        ),
      ),
    );
  }
}
