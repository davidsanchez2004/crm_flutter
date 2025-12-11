import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../models/cliente.dart';
import '../services/clientes_service.dart';
import '../../auth/providers/auth_provider.dart';

final clientesServiceProvider = Provider<ClientesService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final userId = ref.watch(currentUserIdProvider);

  return ClientesService(
    client: supabase,
    userId: userId ?? '',
  );
});

final clientesListProvider = FutureProvider<List<Cliente>>((ref) async {
  final service = ref.watch(clientesServiceProvider);
  return service.obtenerClientes();
});

final crearClienteProvider =
    FutureProvider.family<Cliente, ({String nombre, String email, String telefono, String direccion})>(
  (ref, params) async {
    final service = ref.watch(clientesServiceProvider);
    final cliente = await service.crearCliente(
      nombre: params.nombre,
      email: params.email,
      telefono: params.telefono,
      direccion: params.direccion,
    );
    ref.invalidate(clientesListProvider);
    return cliente;
  },
);

final actualizarClienteProvider = FutureProvider.family<Cliente,
    ({int id, String nombre, String email, String telefono, String direccion})>(
  (ref, params) async {
    final service = ref.watch(clientesServiceProvider);
    final cliente = await service.actualizarCliente(
      id: params.id,
      nombre: params.nombre,
      email: params.email,
      telefono: params.telefono,
      direccion: params.direccion,
    );
    ref.invalidate(clientesListProvider);
    return cliente;
  },
);

final eliminarClienteProvider = FutureProvider.family<void, int>((ref, id) async {
  final service = ref.watch(clientesServiceProvider);
  await service.eliminarCliente(id);
  ref.invalidate(clientesListProvider);
});
