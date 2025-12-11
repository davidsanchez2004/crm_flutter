import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cliente.dart';

class ClientesService {
  final SupabaseClient client;
  final String userId;

  ClientesService({
    required this.client,
    required this.userId,
  });

  Future<List<Cliente>> obtenerClientes() async {
    try {
      final response = await client
          .from('clientes')
          .select()
          .eq('user_id', userId)
          .order('nombre', ascending: true);

      return (response as List).map((e) => Cliente.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Error al obtener clientes: $e');
    }
  }

  Future<Cliente> crearCliente({
    required String nombre,
    required String email,
    required String telefono,
    required String direccion,
  }) async {
    try {
      final response = await client.from('clientes').insert({
        'user_id': userId,
        'nombre': nombre,
        'email': email,
        'telefono': telefono,
        'direccion': direccion,
        'fecha_creacion': DateTime.now().toIso8601String(),
      }).select();

      if (response.isEmpty) throw Exception('No se pudo crear el cliente');
      return Cliente.fromMap(response.first);
    } catch (e) {
      throw Exception('Error al crear cliente: $e');
    }
  }

  Future<Cliente> actualizarCliente({
    required int id,
    required String nombre,
    required String email,
    required String telefono,
    required String direccion,
  }) async {
    try {
      final response = await client
          .from('clientes')
          .update({
            'nombre': nombre,
            'email': email,
            'telefono': telefono,
            'direccion': direccion,
            'fecha_actualizacion': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select();

      if (response.isEmpty) throw Exception('No se pudo actualizar el cliente');
      return Cliente.fromMap(response.first);
    } catch (e) {
      throw Exception('Error al actualizar cliente: $e');
    }
  }

  Future<void> eliminarCliente(int id) async {
    try {
      await client.from('clientes').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar cliente: $e');
    }
  }

  Future<Cliente?> buscarClientePorEmail(String email) async {
    try {
      final response = await client
          .from('clientes')
          .select()
          .eq('user_id', userId)
          .eq('email', email)
          .maybeSingle();

      return response != null ? Cliente.fromMap(response) : null;
    } catch (e) {
      throw Exception('Error al buscar cliente: $e');
    }
  }
}
