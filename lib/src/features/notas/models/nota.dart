class Nota {
  final int? id;
  final String userId;
  final String? ventaId;
  final String? gastoId;
  final String? productoId;
  final String contenido;
  final DateTime fechaCreacion;
  final DateTime? fechaActualizacion;

  Nota({
    this.id,
    required this.userId,
    this.ventaId,
    this.gastoId,
    this.productoId,
    required this.contenido,
    required this.fechaCreacion,
    this.fechaActualizacion,
  });

  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'] as int?,
      userId: map['user_id'] as String,
      ventaId: map['venta_id'] as String?,
      gastoId: map['gasto_id'] as String?,
      productoId: map['producto_id'] as String?,
      contenido: map['contenido'] as String,
      fechaCreacion: DateTime.parse(map['fecha_creacion'] as String),
      fechaActualizacion: map['fecha_actualizacion'] != null
          ? DateTime.parse(map['fecha_actualizacion'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'venta_id': ventaId,
      'gasto_id': gastoId,
      'producto_id': productoId,
      'contenido': contenido,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
    };
  }

  Nota copyWith({
    int? id,
    String? userId,
    String? ventaId,
    String? gastoId,
    String? productoId,
    String? contenido,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return Nota(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ventaId: ventaId ?? this.ventaId,
      gastoId: gastoId ?? this.gastoId,
      productoId: productoId ?? this.productoId,
      contenido: contenido ?? this.contenido,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}
