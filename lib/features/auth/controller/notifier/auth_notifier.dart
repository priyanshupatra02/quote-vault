import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/data/network/supabase_helper_pod.dart';
import 'package:quote_vault/features/auth/controller/state/auth_states.dart';

/// Auth state notifier following AsyncNotifier pattern from eduinfitium_student_flutter
class AuthStateNotifier extends AutoDisposeAsyncNotifier<AuthState> {
  @override
  FutureOr<AuthState> build() {
    // Check current auth status on initialization
    final client = ref.watch(supabaseHelperProvider).client;
    final currentUser = client.auth.currentUser;

    if (currentUser != null) {
      return AuthenticatedState(currentUser);
    }
    return const UnauthenticatedState();
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AsyncData(AuthLoadingState());

    state = await AsyncValue.guard(() async {
      final result = await ref.read(supabaseHelperProvider).signUp(
            email: email,
            password: password,
            name: name,
          );

      return result.when(
        (user) => RegistrationSuccessState(user: user),
        (error) => AuthErrorState(
          message: error.errorMessage,
          statusCode: error.statusCode,
        ),
      );
    });
  }

  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncData(AuthLoadingState());

    state = await AsyncValue.guard(() async {
      final result = await ref.read(supabaseHelperProvider).signIn(
            email: email,
            password: password,
          );

      return result.when(
        (user) => AuthenticatedState(user),
        (error) => AuthErrorState(
          message: error.errorMessage,
          statusCode: error.statusCode,
        ),
      );
    });
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AsyncData(AuthLoadingState());

    state = await AsyncValue.guard(() async {
      final result = await ref.read(supabaseHelperProvider).signOut();

      return result.when(
        (_) => const UnauthenticatedState(),
        (error) => AuthErrorState(message: error.errorMessage),
      );
    });
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    state = const AsyncData(AuthLoadingState());

    state = await AsyncValue.guard(() async {
      final result = await ref.read(supabaseHelperProvider).resetPassword(
            email: email,
          );

      return result.when(
        (_) => PasswordResetSentState(email: email),
        (error) => AuthErrorState(message: error.errorMessage),
      );
    });
  }

  /// Reset state to initial (for navigating back to login)
  void resetState() {
    state = const AsyncData(UnauthenticatedState());
  }
}
