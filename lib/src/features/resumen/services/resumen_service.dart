import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/models/balance.dart';

class ResumenService {
  final SupabaseClient client;
  final String userId;

  ResumenService({
    required this.client,
    required this.userId,
  });

  Future<Balance> obtenerBalance() async {
    try {
      // Query agregadas para obtener totales
      final ventasResponse = await client
          .from('ventas')
          .select('monto')
          .eq('user_id', userId);

      final gastosResponse = await client
          .from('gastos')
          .select('monto')
          .eq('user_id', userId);

      double totalVentas = 0;
      double totalGastos = 0;

      for (var item in ventasResponse) {
        totalVentas += (item['monto'] as num).toDouble();
      }

      for (var item in gastosResponse) {
        totalGastos += (item['monto'] as num).toDouble();
      }

      return Balance(
        ventasTotal: totalVentas,
        gastosTotal: totalGastos,
      );
    } catch (e) {
      throw Exception('Error al obtener balance: $e');
    }
  }

  Future<int> obtenerTotalProductos() async {
    try {
      final response = await client
          .from('productos')
          .select('id')
          .eq('user_id', userId);

      return (response as List).length;
    } catch (e) {
      throw Exception('Error al obtener total de productos: $e');
    }
  }
}
