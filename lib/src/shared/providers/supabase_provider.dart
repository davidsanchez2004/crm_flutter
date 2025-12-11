import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

/// Provider para acceder a la instancia de Supabase en toda la app
final supabaseProvider = Provider<sb.SupabaseClient>((ref) {
  return sb.Supabase.instance.client;
});

/// Provider para obtener el usuario actual autenticado
final currentUserProvider = StreamProvider<sb.AuthState?>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return supabase.auth.onAuthStateChange.map((event) => event.session != null ? event : null);
});
