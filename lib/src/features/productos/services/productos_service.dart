import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/producto.dart';

class ProductosService {
  final SupabaseClient client;
  final String userId;

  ProductosService({
    required this.client,
    required this.userId,
  });

  Future<List<Producto>> obtenerProductos() async {
    try {
      final response = await client
          .from('productos')
          .select()
          .eq('user_id', userId)
          .order('nombre', ascending: true);

      return (response as List).map((e) => Producto.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Error al obtener productos: $e');
    }
  }

  Future<Producto> crearProducto({
    required String nombre,
    required double precioCosto,
    required double precioVenta,
    required double stockActual,
    required double stockMinimo,
    required String descripcion,
  }) async {
    try {
      final response = await client.from('productos').insert({
        'user_id': userId,
        'nombre': nombre,
        'precio_costo': precioCosto,
        'precio_venta': precioVenta,
        'stock_actual': stockActual,
        'stock_minimo': stockMinimo,
        'descripcion': descripcion,
      }).select();

      if (response.isEmpty) throw Exception('No se pudo crear el producto');
      return Producto.fromMap(response.first);
    } catch (e) {
      throw Exception('Error al crear producto: $e');
    }
  }

  Future<void> actualizarStock(int id, double nuevoStock) async {
    try {
      await client.from('productos').update({'stock_actual': nuevoStock}).eq('id', id);
    } catch (e) {
      throw Exception('Error al actualizar stock: $e');
    }
  }

  Future<void> eliminarProducto(int id) async {
    try {
      await client.from('productos').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar producto: $e');
    }
  }

  Future<Producto> actualizarProducto({
    required int id,
    required String nombre,
    required double precioCosto,
    required double precioVenta,
    required double stockActual,
    required double stockMinimo,
    required String descripcion,
  }) async {
    try {
      final response = await client
          .from('productos')
          .update({
            'nombre': nombre,
            'precio_costo': precioCosto,
            'precio_venta': precioVenta,
            'stock_actual': stockActual,
            'stock_minimo': stockMinimo,
            'descripcion': descripcion,
          })
          .eq('id', id)
          .select();

      if (response.isEmpty) throw Exception('No se pudo actualizar el producto');
      return Producto.fromMap(response.first);
    } catch (e) {
      throw Exception('Error al actualizar producto: $e');
    }
  }

  Future<List<Producto>> buscarProductos({
    String? nombre,
    String? descripcion,
    bool? stockBajo,
  }) async {
    try {
      var query = client
          .from('productos')
          .select()
          .eq('user_id', userId);

      if (nombre != null && nombre.isNotEmpty) {
        query = query.ilike('nombre', '%$nombre%');
      }

      if (descripcion != null && descripcion.isNotEmpty) {
        query = query.ilike('descripcion', '%$descripcion%');
      }

      if (stockBajo == true) {
        query = query.lt('stock', 5);
      }

      final response = await query.order('nombre', ascending: true);

      return (response as List).map((e) => Producto.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Error al buscar productos: $e');
    }
  }
}

