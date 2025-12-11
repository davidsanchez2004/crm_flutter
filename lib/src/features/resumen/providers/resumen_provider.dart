import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../shared/providers/supabase_provider.dart';
import '../../../shared/models/balance.dart';
import '../services/resumen_service.dart';
import '../../auth/providers/auth_provider.dart';

final resumenServiceProvider = Provider<ResumenService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  return ResumenService(
    client: supabase,
    userId: userId ?? '',
  );
});

final balanceProvider = FutureProvider<Balance>((ref) async {
  final service = ref.watch(resumenServiceProvider);
  return service.obtenerBalance();
});

final totalProductosProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(resumenServiceProvider);
  return service.obtenerTotalProductos();
});
