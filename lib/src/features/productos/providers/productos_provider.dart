import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../models/producto.dart';
import '../services/productos_service.dart';
import '../../auth/providers/auth_provider.dart';

final productosServiceProvider = Provider<ProductosService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  return ProductosService(
    client: supabase,
    userId: userId ?? '',
  );
});

final productosListProvider = FutureProvider<List<Producto>>((ref) async {
  final service = ref.watch(productosServiceProvider);
  return service.obtenerProductos();
});

final crearProductoProvider = FutureProvider.family<Producto, ({String nombre, double precioCosto, double precioVenta, double stockActual, double stockMinimo, String descripcion})>((ref, params) async {
  final service = ref.watch(productosServiceProvider);
  final producto = await service.crearProducto(
    nombre: params.nombre,
    precioCosto: params.precioCosto,
    precioVenta: params.precioVenta,
    stockActual: params.stockActual,
    stockMinimo: params.stockMinimo,
    descripcion: params.descripcion,
  );
  ref.invalidate(productosListProvider);
  return producto;
});

final actualizarStockProvider = FutureProvider.family<void, ({int id, double stock})>((ref, params) async {
  final service = ref.watch(productosServiceProvider);
  await service.actualizarStock(params.id, params.stock);
  ref.invalidate(productosListProvider);
});

final eliminarProductoProvider = FutureProvider.family<void, int>((ref, id) async {
  final service = ref.watch(productosServiceProvider);
  await service.eliminarProducto(id);
  ref.invalidate(productosListProvider);
});

final actualizarProductoProvider = FutureProvider.family<Producto,
    ({int id, String nombre, double precioCosto, double precioVenta, double stockActual, double stockMinimo, String descripcion})>(
  (ref, params) async {
    final service = ref.watch(productosServiceProvider);
    final producto = await service.actualizarProducto(
      id: params.id,
      nombre: params.nombre,
      precioCosto: params.precioCosto,
      precioVenta: params.precioVenta,
      stockActual: params.stockActual,
      stockMinimo: params.stockMinimo,
      descripcion: params.descripcion,
    );
    ref.invalidate(productosListProvider);
    return producto;
  },
);

final buscarProductosProvider = FutureProvider.family<List<Producto>,
    ({String? nombre, String? descripcion, bool? stockBajo})>(
  (ref, params) async {
    final service = ref.watch(productosServiceProvider);
    return service.buscarProductos(
      nombre: params.nombre,
      descripcion: params.descripcion,
      stockBajo: params.stockBajo,
    );
  },
);
