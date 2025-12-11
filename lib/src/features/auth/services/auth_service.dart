import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient client;

  AuthService({required this.client});

  Future<AuthResponse> signup({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception('Error en registro: ${e.message}');
    } catch (e) {
      throw Exception('Error desconocido: $e');
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception('Error en inicio de sesión: ${e.message}');
    } catch (e) {
      throw Exception('Error desconocido: $e');
    }
  }

  Future<void> logout() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  String? getCurrentUserId() {
    return client.auth.currentUser?.id;
  }

  bool isAuthenticated() {
    return client.auth.currentSession != null;
  }
}
