import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for SupabaseClient instance
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
  name: 'supabaseClientProvider',
);

/// Provider for current authenticated user
final currentUserProvider = Provider<User?>(
  (ref) => ref.watch(supabaseClientProvider).auth.currentUser,
  name: 'currentUserProvider',
);

/// Stream provider for auth state changes
final authStateChangesProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(supabaseClientProvider).auth.onAuthStateChange,
  name: 'authStateChangesProvider',
);
