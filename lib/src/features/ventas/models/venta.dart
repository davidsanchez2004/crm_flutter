class Venta {
  final int id;
  final String userId;
  final int? productoId;
  final int cantidad;
  final double monto;
  final String descripcion;
  final DateTime fecha;
  final DateTime createdAt;

  Venta({
    required this.id,
    required this.userId,
    this.productoId,
    required this.cantidad,
    required this.monto,
    required this.descripcion,
    required this.fecha,
    required this.createdAt,
  });

  factory Venta.fromMap(Map<String, dynamic> map) {
    // Manejo robusto de valores nulos y tipos
    final descripcionValue = map['descripcion'];
    final fechaValue = map['fecha'];
    final createdAtValue = map['created_at'];
    
    return Venta(
      id: map['id'] as int? ?? 0,
      userId: map['user_id'] as String? ?? '',
      productoId: map['producto_id'] as int?,
      cantidad: (map['cantidad'] as num?)?.toInt() ?? 1,
      monto: (map['monto'] as num?)?.toDouble() ?? 0.0,
      descripcion: (descripcionValue ?? 'Sin descripción') as String,
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
      'fecha': fecha.toIso8601String(),
    };
  }

  Venta copyWith({
    int? id,
    String? userId,
    int? productoId,
    int? cantidad,
    double? monto,
    String? descripcion,
    DateTime? fecha,
    DateTime? createdAt,
  }) {
    return Venta(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      monto: monto ?? this.monto,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
