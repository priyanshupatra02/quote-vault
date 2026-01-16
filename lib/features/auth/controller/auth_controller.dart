import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/services/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseAuthServiceProvider = Provider<SupabaseAuthService>((ref) {
  return SupabaseAuthService();
});

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  return AuthController(ref.watch(supabaseAuthServiceProvider));
});

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final SupabaseAuthService _authService;

  AuthController(this._authService) : super(const AsyncValue.data(null)) {
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    final user = _authService.currentUser;
    state = AsyncValue.data(user);
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authService.signUp(email: email, password: password);
      // If email confirmation is enabled, user might be null or session null, but usually we get a user.
      // For now, we assume success if no error.
      state = AsyncValue.data(response.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authService.signIn(email: email, password: password);
      state = AsyncValue.data(response.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAvatar(String url) async {
    try {
      final response = await _authService.updateUser(
        UserAttributes(
          data: {'avatar_url': url},
        ),
      );
      state = AsyncValue.data(response.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateName(String name) async {
    try {
      final response = await _authService.updateUser(
        UserAttributes(
          data: {'full_name': name},
        ),
      );
      state = AsyncValue.data(response.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
