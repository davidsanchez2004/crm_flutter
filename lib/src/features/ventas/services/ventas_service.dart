import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/venta.dart';

class VentasService {
  final SupabaseClient client;
  final String userId;

  VentasService({
    required this.client,
    required this.userId,
  });

  Future<List<Venta>> obtenerVentas() async {
    try {
      final response = await client
          .from('ventas')
          .select()
          .eq('user_id', userId)
          .order('fecha', ascending: false);

      return (response as List).map((e) => Venta.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Error al obtener ventas: $e');
    }
  }

  Future<Venta> crearVenta({
    required double monto,
    required String descripcion,
    required DateTime fecha,
    int? productoId,
    int cantidad = 1,
  }) async {
    try {
      // Validaciones de entrada
      if (descripcion.isEmpty) {
        throw Exception('Descripción no puede estar vacía');
      }
      if (monto <= 0) {
        throw Exception('Monto debe ser mayor a 0');
      }
      if (cantidad <= 0) {
        throw Exception('Cantidad debe ser mayor a 0');
      }

      // Actualizar stock del producto si está asociado
      if (productoId != null && productoId > 0 && cantidad > 0) {
        final producto = await client
            .from('productos')
            .select('stock_actual')
            .eq('id', productoId)
            .single();

        final nuevoStock = (producto['stock_actual'] as num).toDouble() - cantidad;
        if (nuevoStock < 0) {
          throw Exception('Stock insuficiente del producto');
        }

        await client
            .from('productos')
            .update({'stock_actual': nuevoStock})
            .eq('id', productoId);
      }

      final response = await client.from('ventas').insert({
        'user_id': userId,
        'monto': monto,
        'descripcion': descripcion,
        'fecha': fecha.toIso8601String(),
        'producto_id': productoId,
        'cantidad': cantidad,
      }).select();

      if (response.isEmpty) throw Exception('No se pudo crear la venta');
      return Venta.fromMap(response.first);
    } catch (e) {
      throw Exception('Error al crear venta: $e');
    }
  }

  Future<void> eliminarVenta(int id) async {
    try {
      // Obtener la venta para recuperar el stock si tiene producto asociado
      final venta = await client
          .from('ventas')
          .select()
          .eq('id', id)
          .single();

      final ventaData = Venta.fromMap(venta);

      // Recuperar stock del producto
      if (ventaData.productoId != null && ventaData.cantidad > 0) {
        final producto = await client
            .from('productos')
            .select('stock_actual')
            .eq('id', ventaData.productoId!)
            .single();

        final nuevoStock = (producto['stock_actual'] as num).toDouble() + ventaData.cantidad;
        await client
            .from('productos')
            .update({'stock_actual': nuevoStock})
            .eq('id', ventaData.productoId!);
      }

      await client.from('ventas').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar venta: $e');
    }
  }

  Future<Venta> actualizarVenta({
    required int id,
    required double monto,
    required String descripcion,
    required DateTime fecha,
    int? productoId,
    int cantidad = 1,
  }) async {
    try {
      // Obtener venta anterior para ajustar stock
      final ventaAnterior = await client
          .from('ventas')
          .select()
          .eq('id', id)
          .single();

      final ventaData = Venta.fromMap(ventaAnterior);

      // Si el producto cambió o la cantidad cambió, ajustar stock
      if (ventaData.productoId != null && ventaData.cantidad > 0) {
        // Recuperar stock anterior
        final productoAnterior = await client
            .from('productos')
            .select('stock_actual')
            .eq('id', ventaData.productoId!)
            .single();

        final stockRecuperado =
            (productoAnterior['stock_actual'] as num).toDouble() + ventaData.cantidad;
        await client
            .from('productos')
            .update({'stock_actual': stockRecuperado})
            .eq('id', ventaData.productoId!);
      }

      // Restar stock nuevo producto
      if (productoId != null && cantidad > 0) {
        final productoNuevo = await client
            .from('productos')
            .select('stock_actual')
            .eq('id', productoId)
            .single();

        final nuevoStock = (productoNuevo['stock_actual'] as num).toDouble() - cantidad;
        if (nuevoStock < 0) {
          throw Exception('Stock insuficiente del producto');
        }

        await client
            .from('productos')
            .update({'stock_actual': nuevoStock})
            .eq('id', productoId);
      }

      final response = await client
          .from('ventas')
          .update({
            'monto': monto,
            'descripcion': descripcion,
            'fecha': fecha.toIso8601String(),
            'producto_id': productoId,
            'cantidad': cantidad,
          })
          .eq('id', id)
          .select();

      if (response.isEmpty) throw Exception('No se pudo actualizar la venta');
      return Venta.fromMap(response.first);
    } catch (e) {
      throw Exception('Error al actualizar venta: $e');
    }
  }

  Future<List<Venta>> buscarVentas({
    String? descripcion,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      var query = client
          .from('ventas')
          .select()
          .eq('user_id', userId);

      if (descripcion != null && descripcion.isNotEmpty) {
        query = query.ilike('descripcion', '%$descripcion%');
      }

      if (fechaInicio != null) {
        query = query.gte('fecha', fechaInicio.toIso8601String());
      }

      if (fechaFin != null) {
        query = query.lte('fecha', fechaFin.toIso8601String());
      }

      final response = await query.order('fecha', ascending: false);

      return (response as List).map((e) => Venta.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Error al buscar ventas: $e');
    }
  }
}
