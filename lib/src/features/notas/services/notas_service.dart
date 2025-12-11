import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/nota.dart';

class NotasService {
  final SupabaseClient client;
  final String userId;

  NotasService({
    required this.client,
    required this.userId,
  });

  Future<List<Nota>> obtenerNotas({
    String? ventaId,
    String? gastoId,
    String? productoId,
  }) async {
    try {
      var query = client
          .from('notas')
          .select()
          .eq('user_id', userId);

      if (ventaId != null) {
        query = query.eq('venta_id', ventaId);
      } else if (gastoId != null) {
        query = query.eq('gasto_id', gastoId);
      } else if (productoId != null) {
        query = query.eq('producto_id', productoId);
      }

      final response = await query.order('fecha_creacion', ascending: false);

      return (response as List).map((e) => Nota.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Error al obtener notas: $e');
    }
  }

  Future<Nota> crearNota({
    required String contenido,
    String? ventaId,
    String? gastoId,
    String? productoId,
  }) async {
    try {
      final response = await client.from('notas').insert({
        'user_id': userId,
        'venta_id': ventaId,
        'gasto_id': gastoId,
        'producto_id': productoId,
        'contenido': contenido,
        'fecha_creacion': DateTime.now().toIso8601String(),
      }).select();

      if (response.isEmpty) throw Exception('No se pudo crear la nota');
      return Nota.fromMap(response.first);
    } catch (e) {
      throw Exception('Error al crear nota: $e');
    }
  }

  Future<Nota> actualizarNota({
    required int id,
    required String contenido,
  }) async {
    try {
      final response = await client
          .from('notas')
          .update({
            'contenido': contenido,
            'fecha_actualizacion': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select();

      if (response.isEmpty) throw Exception('No se pudo actualizar la nota');
      return Nota.fromMap(response.first);
    } catch (e) {
      throw Exception('Error al actualizar nota: $e');
    }
  }

  Future<void> eliminarNota(int id) async {
    try {
      await client.from('notas').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar nota: $e');
    }
  }
}
