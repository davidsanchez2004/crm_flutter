import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../shared/providers/supabase_provider.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return AuthService(client: supabase);
});

final authStateProvider = StreamProvider<sb.AuthState?>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return supabase.auth.onAuthStateChange.map((event) => event.session != null ? event : null);
});

final signupProvider = FutureProvider.family<sb.AuthResponse, ({String email, String password})>((ref, params) async {
  final authService = ref.watch(authServiceProvider);
  return authService.signup(email: params.email, password: params.password);
});

final loginProvider = FutureProvider.family<sb.AuthResponse, ({String email, String password})>((ref, params) async {
  final authService = ref.watch(authServiceProvider);
  return authService.login(email: params.email, password: params.password);
});

final logoutProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.logout();
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.getCurrentUserId();
});

final currentUserProvider = Provider<sb.User?>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return supabase.auth.currentUser;
});
