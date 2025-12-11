class Notificacion {
  final int id;
  final String userId;
  final String titulo;
  final String mensaje;
  final String tipo; // info, success, warning, error
  final bool leida;
  final DateTime fechaCreacion;

  Notificacion({
    required this.id,
    required this.userId,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    required this.leida,
    required this.fechaCreacion,
  });

  factory Notificacion.fromMap(Map<String, dynamic> map) {
    return Notificacion(
      id: map['id'] as int,
      userId: map['user_id'] as String,
      titulo: map['titulo'] as String,
      mensaje: map['mensaje'] as String,
      tipo: map['tipo'] as String,
      leida: map['leida'] as bool? ?? false,
      fechaCreacion: DateTime.parse(map['fecha_creacion'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'titulo': titulo,
      'mensaje': mensaje,
      'tipo': tipo,
      'leida': leida,
      'fecha_creacion': fechaCreacion.toIso8601String(),
    };
  }

  Notificacion copyWith({
    int? id,
    String? userId,
    String? titulo,
    String? mensaje,
    String? tipo,
    bool? leida,
    DateTime? fechaCreacion,
  }) {
    return Notificacion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      titulo: titulo ?? this.titulo,
      mensaje: mensaje ?? this.mensaje,
      tipo: tipo ?? this.tipo,
      leida: leida ?? this.leida,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
