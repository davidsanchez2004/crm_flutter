class Gasto {
  final int id;
  final String userId;
  final int? productoId;
  final int cantidad;
  final double monto;
  final String descripcion;
  final String categoria;
  final DateTime fecha;
  final DateTime createdAt;

  Gasto({
    required this.id,
    required this.userId,
    this.productoId,
    required this.cantidad,
    required this.monto,
    required this.descripcion,
    required this.categoria,
    required this.fecha,
    required this.createdAt,
  });

  factory Gasto.fromMap(Map<String, dynamic> map) {
    // Manejo robusto de valores nulos y tipos
    final descripcionValue = map['descripcion'];
    final categoriaValue = map['categoria'];
    final fechaValue = map['fecha'];
    final createdAtValue = map['created_at'];
    
    return Gasto(
      id: map['id'] as int? ?? 0,
      userId: map['user_id'] as String? ?? '',
      productoId: map['producto_id'] as int?,
      cantidad: (map['cantidad'] as num?)?.toInt() ?? 1,
      monto: (map['monto'] as num?)?.toDouble() ?? 0.0,
      descripcion: (descripcionValue ?? 'Sin descripción') as String,
      categoria: (categoriaValue ?? 'Otros') as String,
      fecha: fechaValue != null
          ? DateTime.parse(fechaValue.toString())
          : DateTime.now(),
      createdAt: createdAtValue != null
          ? DateTime.parse(createdAtValue.toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'producto_id': productoId,
      'cantidad': cantidad,
      'monto': monto,
      'descripcion': descripcion,
      'categoria': categoria,
      'fecha': fecha.toIso8601String(),
    };
  }

  Gasto copyWith({
    int? id,
    String? userId,
    int? productoId,
    int? cantidad,
    double? monto,
    String? descripcion,
    String? categoria,
    DateTime? fecha,
    DateTime? createdAt,
  }) {
    return Gasto(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      monto: monto ?? this.monto,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      fecha: fecha ?? this.fecha,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
