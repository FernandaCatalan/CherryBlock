import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import '../services/rating.dart';

class FeedbackPage extends StatefulWidget {
  static const routeName = '/feedback';
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _opinionController = TextEditingController();
  Map<String, List<Pregunta>> categorias = {};

  @override
  void initState() {
    super.initState();
    _cargarPreguntas();
  }

  Future<void> _cargarPreguntas() async {
    final data = await rootBundle.loadString('lib/services/rating.json');
    final jsonData = json.decode(data) as Map<String, dynamic>;

    final Map<String, List<Pregunta>> temp = {};
    jsonData.forEach((key, value) {
      temp[key] = (value as List).map((e) => Pregunta.fromJson(e)).toList();
    });

    setState(() {
      categorias = temp;
    });
  }

  Future<void> _enviarCorreo() async {
    final id = _idController.text.trim();
    final opinion = _opinionController.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tu identificación')),
      );
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('Retroalimentación de usuario: $id\n');
    categorias.forEach((categoria, preguntas) {
      buffer.writeln(categoria);
      for (var p in preguntas) {
        buffer.writeln(p.titulo);
        buffer.writeln('Calificación: ${p.valor.toStringAsFixed(1)} / 5');
        buffer.writeln('');
      }
    });

    if (opinion.isNotEmpty) {
      buffer.writeln('Comentario adicional:');
      buffer.writeln(opinion);
      buffer.writeln('');
    }

    final subject = Uri.encodeComponent('Retroalimentación de $id');
    final body = Uri.encodeComponent(buffer.toString());

    final Uri emailUri = Uri.parse(
      'mailto:fernanda.catalan.contact@gmail.com?subject=$subject&body=$body',
    );

    if (!await launchUrl(emailUri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir la aplicación de correo'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categorias.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Retroalimentación')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'Tu identificación',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  ...categorias.entries.map(
                    (entry) => _buildCategoria(entry.key, entry.value),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _opinionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: '¿Tienes algún comentario adicional?',
                      hintText: 'Escribe tu opinión o sugerencia aquí...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text('Enviar Retroalimentación'),
              onPressed: _enviarCorreo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoria(String nombre, List<Pregunta> preguntas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          nombre.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        ...preguntas.map((p) => _buildPregunta(p)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPregunta(Pregunta pregunta) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(pregunta.titulo),
        Center(
          child: RatingBar.builder(
            initialRating: pregunta.valor,
            minRating: 0,
            direction: Axis.horizontal,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder:
                (context, _) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              setState(() {
                pregunta.valor = rating;
              });
            },
          ),
        ),
        SizedBox(height: 4),
        Text(
          pregunta.min,
          style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
        ),
        Text(
          pregunta.max,
          style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}