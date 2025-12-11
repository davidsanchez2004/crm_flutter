class Cliente {
  final int? id;
  final String userId;
  final String nombre;
  final String email;
  final String telefono;
  final String direccion;
  final DateTime fechaCreacion;
  final DateTime? fechaActualizacion;

  Cliente({
    this.id,
    required this.userId,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.direccion,
    required this.fechaCreacion,
    this.fechaActualizacion,
  });

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'] as int?,
      userId: map['user_id'] as String,
      nombre: map['nombre'] as String,
      email: map['email'] as String,
      telefono: map['telefono'] as String,
      direccion: map['direccion'] as String,
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
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'direccion': direccion,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
    };
  }

  Cliente copyWith({
    int? id,
    String? userId,
    String? nombre,
    String? email,
    String? telefono,
    String? direccion,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return Cliente(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }
}
