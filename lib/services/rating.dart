class Pregunta {
  final String titulo;
  final String min;
  final String max;
  double valor;

  Pregunta({
    required this.titulo,
    required this.min,
    required this.max,
    this.valor = 0,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      titulo: json['titulo'],
      min: json['min'],
      max: json['max'],
      valor: (json['valor'] as num).toDouble(),
    );
  }
}