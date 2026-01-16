import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/features/auth/controller/notifier/auth_notifier.dart';
import 'package:quote_vault/features/auth/controller/state/auth_states.dart';

/// Provider for auth state - the main access point for auth operations
final authStateProvider = AsyncNotifierProvider.autoDispose<AuthStateNotifier, AuthState>(
  AuthStateNotifier.new,
  name: 'authStateProvider',
);

/// Convenience provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(
        data: (state) => state is AuthenticatedState,
      ) ??
      false;
});

/// Convenience provider to get current user ID (null if not authenticated)
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(
    data: (state) {
      if (state is AuthenticatedState) {
        return state.user.id;
      }
      return null;
    },
  );
});
