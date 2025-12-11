import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../models/nota.dart';
import '../services/notas_service.dart';
import '../../auth/providers/auth_provider.dart';

final notasServiceProvider = Provider<NotasService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final userId = ref.watch(currentUserIdProvider);

  return NotasService(
    client: supabase,
    userId: userId ?? '',
  );
});

final notasProvider = FutureProvider.family<List<Nota>, ({String? ventaId, String? gastoId, String? productoId})>(
  (ref, params) async {
    final service = ref.watch(notasServiceProvider);
    return service.obtenerNotas(
      ventaId: params.ventaId,
      gastoId: params.gastoId,
      productoId: params.productoId,
    );
  },
);

final crearNotaProvider = FutureProvider.family<Nota,
    ({String contenido, String? ventaId, String? gastoId, String? productoId})>(
  (ref, params) async {
    final service = ref.watch(notasServiceProvider);
    final nota = await service.crearNota(
      contenido: params.contenido,
      ventaId: params.ventaId,
      gastoId: params.gastoId,
      productoId: params.productoId,
    );
    ref.invalidate(notasProvider);
    return nota;
  },
);

final actualizarNotaProvider = FutureProvider.family<Nota, ({int id, String contenido})>(
  (ref, params) async {
    final service = ref.watch(notasServiceProvider);
    final nota = await service.actualizarNota(
      id: params.id,
      contenido: params.contenido,
    );
    ref.invalidate(notasProvider);
    return nota;
  },
);

final eliminarNotaProvider = FutureProvider.family<void, int>((ref, id) async {
  final service = ref.watch(notasServiceProvider);
  await service.eliminarNota(id);
  ref.invalidate(notasProvider);
});
