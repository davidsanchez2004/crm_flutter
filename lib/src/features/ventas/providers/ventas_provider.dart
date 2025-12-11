import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../models/venta.dart';
import '../services/ventas_service.dart';
import '../../auth/providers/auth_provider.dart';

final ventasServiceProvider = Provider<VentasService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  return VentasService(
    client: supabase,
    userId: userId ?? '',
  );
});

final ventasListProvider = FutureProvider<List<Venta>>((ref) async {
  final service = ref.watch(ventasServiceProvider);
  return service.obtenerVentas();
});

final allVentasProvider = FutureProvider<List<Venta>>((ref) async {
  final service = ref.watch(ventasServiceProvider);
  return service.obtenerVentas();
});

final crearVentaProvider = FutureProvider.family<Venta, ({double monto, String descripcion, DateTime fecha})>((ref, params) async {
  final service = ref.watch(ventasServiceProvider);
  final venta = await service.crearVenta(
    monto: params.monto,
    descripcion: params.descripcion,
    fecha: params.fecha,
  );
  // Invalidar la lista para refrescar
  ref.invalidate(ventasListProvider);
  return venta;
});

final eliminarVentaProvider = FutureProvider.family<void, int>((ref, id) async {
  final service = ref.watch(ventasServiceProvider);
  await service.eliminarVenta(id);
  ref.invalidate(ventasListProvider);
});

final actualizarVentaProvider = FutureProvider.family<Venta,
    ({int id, double monto, String descripcion, DateTime fecha})>((ref, params) async {
  final service = ref.watch(ventasServiceProvider);
  final venta = await service.actualizarVenta(
    id: params.id,
    monto: params.monto,
    descripcion: params.descripcion,
    fecha: params.fecha,
  );
  ref.invalidate(ventasListProvider);
  return venta;
});

final buscarVentasProvider = FutureProvider.family<List<Venta>,
    ({String? descripcion, DateTime? fechaInicio, DateTime? fechaFin})>(
  (ref, params) async {
    final service = ref.watch(ventasServiceProvider);
    return service.buscarVentas(
      descripcion: params.descripcion,
      fechaInicio: params.fechaInicio,
      fechaFin: params.fechaFin,
    );
  },
);
