import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notificacion.dart';

class NotificacionesService {
  final SupabaseClient client;

  NotificacionesService({required this.client});

  Future<Notificacion> crearNotificacion({
    required String titulo,
    required String mensaje,
    required String tipo,
    required String userId,
  }) async {
    try {
      final response = await client.from('notificaciones').insert({
        'user_id': userId,
        'titulo': titulo,
        'mensaje': mensaje,
        'tipo': tipo,
        'leida': false,
        'fecha_creacion': DateTime.now().toIso8601String(),
      }).select();

      if (response.isEmpty) {
        throw Exception('No se pudo crear la notificación');
      }

      return Notificacion.fromMap(response.first);
    } catch (e) {
      throw Exception('Error al crear notificación: $e');
    }
  }

  Future<List<Notificacion>> obtenerNotificaciones(String userId) async {
    try {
      final response = await client
          .from('notificaciones')
          .select()
          .eq('user_id', userId)
          .order('fecha_creacion', ascending: false);

      return (response as List)
          .map((e) => Notificacion.fromMap(e))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener notificaciones: $e');
    }
  }

  Future<List<Notificacion>> obtenerNotificacionesNoLeidas(String userId) async {
    try {
      final response = await client
          .from('notificaciones')
          .select()
          .eq('user_id', userId)
          .eq('leida', false)
          .order('fecha_creacion', ascending: false);

      return (response as List)
          .map((e) => Notificacion.fromMap(e))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener notificaciones no leídas: $e');
    }
  }

  Future<void> marcarComoLeida(int id) async {
    try {
      await client
          .from('notificaciones')
          .update({'leida': true}).eq('id', id);
    } catch (e) {
      throw Exception('Error al marcar notificación como leída: $e');
    }
  }

  Future<void> marcarTodasComoLeidas(String userId) async {
    try {
      await client
          .from('notificaciones')
          .update({'leida': true})
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Error al marcar notificaciones como leídas: $e');
    }
  }

  Future<void> eliminarNotificacion(int id) async {
    try {
      await client.from('notificaciones').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar notificación: $e');
    }
  }

  Future<void> eliminarTodas(String userId) async {
    try {
      await client
          .from('notificaciones')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Error al eliminar notificaciones: $e');
    }
  }
}
