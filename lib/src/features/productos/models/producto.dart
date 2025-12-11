class Producto {
  final int id;
  final String userId;
  final String nombre;
  final String descripcion;
  final double precioCosto;
  final double precioVenta;
  final double stockActual;
  final double stockMinimo;
  final DateTime createdAt;

  Producto({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.descripcion,
    required this.precioCosto,
    required this.precioVenta,
    required this.stockActual,
    required this.stockMinimo,
    required this.createdAt,
  });

  // Getter para estado de stock
  bool get stockBajo => stockActual <= stockMinimo;
  bool get sinStock => stockActual <= 0;
  double get ganancia => (precioVenta - precioCosto) * stockActual;

  factory Producto.fromMap(Map<String, dynamic> map) {
    try {
      // Intentar obtener createdAt de diferentes posibles nombres de columna
      DateTime parsedDate = DateTime.now();
      if (map['created_at'] != null) {
        parsedDate = DateTime.parse(map['created_at'].toString());
      } else if (map['fecha_creacion'] != null) {
        parsedDate = DateTime.parse(map['fecha_creacion'].toString());
      }

      return Producto(
        id: (map['id'] as num).toInt(),
        userId: map['user_id'].toString(),
        nombre: (map['nombre'] ?? '').toString(),
        descripcion: (map['descripcion'] ?? '').toString(),
        precioCosto: (map['precio_costo'] as num?)?.toDouble() ?? 0.0,
        precioVenta: (map['precio_venta'] as num?)?.toDouble() ?? 0.0,
        stockActual: (map['stock_actual'] as num?)?.toDouble() ?? 0.0,
        stockMinimo: (map['stock_minimo'] as num?)?.toDouble() ?? 10.0,
        createdAt: parsedDate,
      );
    } catch (e) {
      throw Exception('Error parseando Producto: $e, datos: $map');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio_costo': precioCosto,
      'precio_venta': precioVenta,
      'stock_actual': stockActual,
      'stock_minimo': stockMinimo,
    };
  }

  Producto copyWith({
    int? id,
    String? userId,
    String? nombre,
    String? descripcion,
    double? precioCosto,
    double? precioVenta,
    double? stockActual,
    double? stockMinimo,
    DateTime? createdAt,
  }) {
    return Producto(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precioCosto: precioCosto ?? this.precioCosto,
      precioVenta: precioVenta ?? this.precioVenta,
      stockActual: stockActual ?? this.stockActual,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
