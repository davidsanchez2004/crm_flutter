import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../models/gasto.dart';
import '../services/gastos_service.dart';
import '../../auth/providers/auth_provider.dart';

final gastosServiceProvider = Provider<GastosService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  return GastosService(
    client: supabase,
    userId: userId ?? '',
  );
});

final gastosListProvider = FutureProvider<List<Gasto>>((ref) async {
  final service = ref.watch(gastosServiceProvider);
  return service.obtenerGastos();
});

final allGastosProvider = FutureProvider<List<Gasto>>((ref) async {
  final service = ref.watch(gastosServiceProvider);
  return service.obtenerGastos();
});

final crearGastoProvider = FutureProvider.family<Gasto, ({double monto, String descripcion, String categoria, DateTime fecha})>((ref, params) async {
  final service = ref.watch(gastosServiceProvider);
  final gasto = await service.crearGasto(
    monto: params.monto,
    descripcion: params.descripcion,
    categoria: params.categoria,
    fecha: params.fecha,
  );
  ref.invalidate(gastosListProvider);
  return gasto;
});

final eliminarGastoProvider = FutureProvider.family<void, int>((ref, id) async {
  final service = ref.watch(gastosServiceProvider);
  await service.eliminarGasto(id);
  ref.invalidate(gastosListProvider);
});

final actualizarGastoProvider = FutureProvider.family<Gasto,
    ({int id, double monto, String descripcion, String categoria, DateTime fecha})>(
  (ref, params) async {
    final service = ref.watch(gastosServiceProvider);
    final gasto = await service.actualizarGasto(
      id: params.id,
      monto: params.monto,
      descripcion: params.descripcion,
      categoria: params.categoria,
      fecha: params.fecha,
    );
    ref.invalidate(gastosListProvider);
    return gasto;
  },
);

final buscarGastosProvider = FutureProvider.family<List<Gasto>,
    ({String? descripcion, String? categoria, DateTime? fechaInicio, DateTime? fechaFin})>(
  (ref, params) async {
    final service = ref.watch(gastosServiceProvider);
    return service.buscarGastos(
      descripcion: params.descripcion,
      categoria: params.categoria,
      fechaInicio: params.fechaInicio,
      fechaFin: params.fechaFin,
    );
  },
);
