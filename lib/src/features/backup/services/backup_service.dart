import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

class BackupService {
  final SupabaseClient client;

  BackupService({required this.client});

  Future<Map<String, dynamic>> crearBackupCompleto(String userId) async {
    try {
      final ventas = await client
          .from('ventas')
          .select()
          .eq('user_id', userId);
      
      final gastos = await client
          .from('gastos')
          .select()
          .eq('user_id', userId);
      
      final productos = await client
          .from('productos')
          .select()
          .eq('user_id', userId);
      
      final clientes = await client
          .from('clientes')
          .select()
          .eq('user_id', userId);
      
      final notas = await client
          .from('notas')
          .select()
          .eq('user_id', userId);
      
      final notificaciones = await client
          .from('notificaciones')
          .select()
          .eq('user_id', userId);

      final backup = {
        'timestamp': DateTime.now().toIso8601String(),
        'user_id': userId,
        'ventas': ventas,
        'gastos': gastos,
        'productos': productos,
        'clientes': clientes,
        'notas': notas,
        'notificaciones': notificaciones,
      };

      return backup;
    } catch (e) {
      throw Exception('Error al crear backup: $e');
    }
  }

  Future<void> guardarBackupEnStorage(
    String userId,
    Map<String, dynamic> backupData,
  ) async {
    try {
      final backupJson = jsonEncode(backupData);
      final timestamp = DateTime.now().toIso8601String();

      // Guardar en tabla de backups en lugar de storage
      await client.from('backups').insert({
        'user_id': userId,
        'contenido': backupJson,
        'fecha_backup': timestamp,
      });
    } catch (e) {
      throw Exception('Error al guardar backup: $e');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerBackupsGuardados(String userId) async {
    try {
      final backups = await client
          .from('backups')
          .select()
          .eq('user_id', userId)
          .order('fecha_backup', ascending: false);
      
      return List<Map<String, dynamic>>.from(backups);
    } catch (e) {
      throw Exception('Error al obtener backups: $e');
    }
  }

  Future<String> descargarBackup(int backupId) async {
    try {
      final backup = await client
          .from('backups')
          .select('contenido')
          .eq('id', backupId)
          .single();
      
      return backup['contenido'] as String;
    } catch (e) {
      throw Exception('Error al descargar backup: $e');
    }
  }

  Future<void> eliminarBackup(int backupId) async {
    try {
      await client
          .from('backups')
          .delete()
          .eq('id', backupId);
    } catch (e) {
      throw Exception('Error al eliminar backup: $e');
    }
  }

  Future<bool> verificarIntegridad(Map<String, dynamic> backup) async {
    try {
      // Verificar que todos los campos requeridos existan
      final requiredKeys = [
        'timestamp',
        'user_id',
        'ventas',
        'gastos',
        'productos',
        'clientes',
        'notas',
        'notificaciones',
      ];

      for (final key in requiredKeys) {
        if (!backup.containsKey(key)) {
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
