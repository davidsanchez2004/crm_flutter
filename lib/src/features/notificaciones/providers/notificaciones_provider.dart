import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../../productos/models/producto.dart';
import '../../productos/providers/productos_provider.dart';
import '../models/notificacion.dart';
import '../services/notificaciones_service.dart';

final notificacionesServiceProvider = Provider<NotificacionesService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return NotificacionesService(client: supabase);
});

final notificacionesListProvider =
    FutureProvider<List<Notificacion>>((ref) async {
  final supabase = ref.watch(supabaseProvider);
  final userId = supabase.auth.currentUser!.id;
  final service = ref.watch(notificacionesServiceProvider);
  return service.obtenerNotificaciones(userId);
});

final notificacionesNoLeidasProvider =
    FutureProvider<List<Notificacion>>((ref) async {
  final supabase = ref.watch(supabaseProvider);
  final userId = supabase.auth.currentUser!.id;
  final service = ref.watch(notificacionesServiceProvider);
  return service.obtenerNotificacionesNoLeidas(userId);
});

final crearNotificacionProvider = FutureProvider.family<Notificacion,
    ({String titulo, String mensaje, String tipo})>((ref, params) async {
  final supabase = ref.watch(supabaseProvider);
  final userId = supabase.auth.currentUser!.id;
  final service = ref.watch(notificacionesServiceProvider);
  final notificacion = await service.crearNotificacion(
    titulo: params.titulo,
    mensaje: params.mensaje,
    tipo: params.tipo,
    userId: userId,
  );
  ref.invalidate(notificacionesListProvider);
  ref.invalidate(notificacionesNoLeidasProvider);
  return notificacion;
});

final marcarComoLeidaProvider =
    FutureProvider.family<void, int>((ref, id) async {
  final service = ref.watch(notificacionesServiceProvider);
  await service.marcarComoLeida(id);
  ref.invalidate(notificacionesListProvider);
  ref.invalidate(notificacionesNoLeidasProvider);
});

final marcarTodasComoLeidasProvider =
    FutureProvider<void>((ref) async {
  final supabase = ref.watch(supabaseProvider);
  final userId = supabase.auth.currentUser!.id;
  final service = ref.watch(notificacionesServiceProvider);
  await service.marcarTodasComoLeidas(userId);
  ref.invalidate(notificacionesListProvider);
  ref.invalidate(notificacionesNoLeidasProvider);
});

final eliminarNotificacionProvider =
    FutureProvider.family<void, int>((ref, id) async {
  final service = ref.watch(notificacionesServiceProvider);
  await service.eliminarNotificacion(id);
  ref.invalidate(notificacionesListProvider);
  ref.invalidate(notificacionesNoLeidasProvider);
});

// Providers para bajo stock
final productosConBajoStockProvider = Provider<List<Producto>>((ref) {
  final productosAsync = ref.watch(productosListProvider);

  return productosAsync.maybeWhen(
    data: (productos) {
      return productos.where((p) => p.stockActual <= p.stockMinimo).toList();
    },
    orElse: () => [],
  );
});

final tieneNotificacionesSinLeerProvider = Provider<bool>((ref) {
  final bajoStock = ref.watch(productosConBajoStockProvider);
  return bajoStock.isNotEmpty;
});
