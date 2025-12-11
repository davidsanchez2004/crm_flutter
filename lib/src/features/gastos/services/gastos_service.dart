import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/gasto.dart';

class GastosService {
  final SupabaseClient client;
  final String userId;

  GastosService({
    required this.client,
    required this.userId,
  });

  Future<List<Gasto>> obtenerGastos() async {
    try {
      final response = await client
          .from('gastos')
          .select()
          .eq('user_id', userId)
          .order('fecha', ascending: false);

      return (response as List).map((e) => Gasto.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Error al obtener gastos: $e');
    }
  }

  Future<Gasto> crearGasto({
    required double monto,
    required String descripcion,
    required String categoria,
    required DateTime fecha,
    int? productoId,
    int? cantidad,
  }) async {
    try {
      // Validaciones de entrada
      if (descripcion.isEmpty) {
        throw Exception('Descripción no puede estar vacía');
      }
      if (monto <= 0) {
        throw Exception('Monto debe ser mayor a 0');
      }
      if (categoria.isEmpty) {
        throw Exception('Categoría no puede estar vacía');
      }

      // Validar límite de crédito (-1000)
      final ventasResponse = await client
          .from('ventas')
          .select('monto')
          .eq('user_id', userId);
      
      final gastosResponse = await client
          .from('gastos')
          .select('monto')
          .eq('user_id', userId);

      final totalVentas = (ventasResponse as List).fold<double>(
        0.0,
        (sum, e) => sum + ((e['monto'] as num?)?.toDouble() ?? 0),
      );

      final totalGastos = (gastosResponse as List).fold<double>(
        0.0,
        (sum, e) => sum + ((e['monto'] as num?)?.toDouble() ?? 0),
      );

      final balanceActual = totalVentas - totalGastos;
      final balanceNuevo = balanceActual - monto;

      // Verificar que no baje de -1000
      if (balanceNuevo < -1000) {
        final faltante = (balanceNuevo + 1000).abs();
        throw Exception(
          'Límite de crédito excedido.\n\n'
          'Balance actual: \$${balanceActual.toStringAsFixed(2)}\n'
          'Límite permitido: -\$1000.00\n'
          'Te faltarían: \$${faltante.toStringAsFixed(2)}'
        );
      }

      // Si es una compra de producto (categoria 'compra' o hay producto_id), agregar stock
      if (productoId != null && productoId > 0 && cantidad != null && cantidad > 0) {
        final producto = await client
            .from('productos')
            .select('stock_actual')
            .eq('id', productoId)
            .single();

        final nuevoStock = (producto['stock_actual'] as num).toDouble() + cantidad;
        await client
            .from('productos')
            .update({'stock_actual': nuevoStock})
            .eq('id', productoId);
      }

      final response = await client.from('gastos').insert({
        'user_id': userId,
        'monto': monto,
        'descripcion': descripcion,
        'categoria': categoria,
        'fecha': fecha.toIso8601String(),
        'producto_id': productoId,
        'cantidad': cantidad ?? 0,
      }).select();

      if (response.isEmpty) throw Exception('No se pudo crear el gasto');
      return Gasto.fromMap(response.first);
    } catch (e) {
      throw Exception('Error al crear gasto: $e');
    }
  }

  Future<void> eliminarGasto(int id) async {
    try {
      // Obtener el gasto para recuperar el stock si tiene producto asociado
      final gasto = await client
          .from('gastos')
          .select()
          .eq('id', id)
          .single();

      final gastoData = Gasto.fromMap(gasto);
      final productoId = gasto['producto_id'] as int?;
      final cantidad = (gasto['cantidad'] as num?)?.toInt() ?? 0;

      // Recuperar stock del producto si fue una compra
      if (productoId != null && cantidad > 0) {
        final producto = await client
            .from('productos')
            .select('stock_actual')
            .eq('id', productoId)
            .single();

        final nuevoStock = (producto['stock_actual'] as num).toDouble() - cantidad;
        if (nuevoStock < 0) {
          // No aplicar restricción en recuperación de stock
          await client
              .from('productos')
              .update({'stock_actual': 0})
              .eq('id', productoId);
        } else {
          await client
              .from('productos')
              .update({'stock_actual': nuevoStock})
              .eq('id', productoId);
        }
      }

      await client.from('gastos').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar gasto: $e');
    }
  }

  Future<Gasto> actualizarGasto({
    required int id,
    required double monto,
    required String descripcion,
    required String categoria,
    required DateTime fecha,
    int? productoId,
    int cantidad = 0,
  }) async {
    try {
      // Obtener gasto anterior
      final gastoAnterior = await client
          .from('gastos')
          .select()
          .eq('id', id)
          .single();

      final productoIdAnterior = gastoAnterior['producto_id'] as int?;
      final cantidadAnterior = (gastoAnterior['cantidad'] as num?)?.toInt() ?? 0;

      // Si el producto cambió o la cantidad cambió, ajustar stock
      if (productoIdAnterior != null && cantidadAnterior > 0) {
        // Recuperar stock anterior
        final productoAnterior = await client
            .from('productos')
            .select('stock_actual')
            .eq('id', productoIdAnterior)
            .single();

        final stockRecuperado =
            (productoAnterior['stock_actual'] as num).toDouble() - cantidadAnterior;
        await client
            .from('productos')
            .update({'stock_actual': stockRecuperado})
            .eq('id', productoIdAnterior);
      }

      // Agregar stock nuevo producto
      if (productoId != null && cantidad > 0) {
        final productoNuevo = await client
            .from('productos')
            .select('stock_actual')
            .eq('id', productoId)
            .single();

        final nuevoStock = (productoNuevo['stock_actual'] as num).toDouble() + cantidad;
        await client
            .from('productos')
            .update({'stock_actual': nuevoStock})
            .eq('id', productoId);
      }

      final response = await client
          .from('gastos')
          .update({
            'monto': monto,
            'descripcion': descripcion,
            'categoria': categoria,
            'fecha': fecha.toIso8601String(),
            'producto_id': productoId,
            'cantidad': cantidad,
          })
          .eq('id', id)
          .select();

      if (response.isEmpty) throw Exception('No se pudo actualizar el gasto');
      return Gasto.fromMap(response.first);
    } catch (e) {
      throw Exception('Error al actualizar gasto: $e');
    }
  }

  Future<List<Gasto>> buscarGastos({
    String? descripcion,
    String? categoria,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    try {
      var query = client
          .from('gastos')
          .select()
          .eq('user_id', userId);

      if (descripcion != null && descripcion.isNotEmpty) {
        query = query.ilike('descripcion', '%$descripcion%');
      }

      if (categoria != null && categoria.isNotEmpty) {
        query = query.eq('categoria', categoria);
      }

      if (fechaInicio != null) {
        query = query.gte('fecha', fechaInicio.toIso8601String());
      }

      if (fechaFin != null) {
        query = query.lte('fecha', fechaFin.toIso8601String());
      }

      final response = await query.order('fecha', ascending: false);

      return (response as List).map((e) => Gasto.fromMap(e)).toList();
    } catch (e) {
      throw Exception('Error al buscar gastos: $e');
    }
  }
}
