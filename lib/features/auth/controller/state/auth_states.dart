import 'package:supabase_flutter/supabase_flutter.dart';

/// Sealed class for auth states following the pattern from eduinfitium_student_flutter
sealed class AuthState {
  const AuthState();
}

/// Initial state - checking auth status
class AuthInitialState implements AuthState {
  const AuthInitialState();
}

/// Loading state - auth operation in progress
class AuthLoadingState implements AuthState {
  const AuthLoadingState();
}

/// Authenticated state - user is logged in
class AuthenticatedState implements AuthState {
  final User user;

  const AuthenticatedState(this.user);

  @override
  bool operator ==(covariant AuthenticatedState other) {
    if (identical(this, other)) return true;
    return other.user.id == user.id;
  }

  @override
  int get hashCode => user.id.hashCode;
}

/// Unauthenticated state - user is not logged in
class UnauthenticatedState implements AuthState {
  const UnauthenticatedState();
}

/// Registration successful state
class RegistrationSuccessState implements AuthState {
  final User user;
  final String message;

  const RegistrationSuccessState({
    required this.user,
    this.message = 'Account created successfully!',
  });
}

/// Password reset email sent state
class PasswordResetSentState implements AuthState {
  final String email;
  final String message;

  const PasswordResetSentState({
    required this.email,
    this.message = 'Password reset email sent!',
  });
}

/// Auth error state
class AuthErrorState implements AuthState {
  final String message;
  final int? statusCode;

  const AuthErrorState({
    required this.message,
    this.statusCode,
  });

  @override
  bool operator ==(covariant AuthErrorState other) {
    if (identical(this, other)) return true;
    return other.message == message && other.statusCode == statusCode;
  }

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;
}
