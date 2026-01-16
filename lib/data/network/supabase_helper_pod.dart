import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/data/network/supabase_client_pod.dart';
import 'package:quote_vault/data/network/supabase_helper.dart';

/// Provider for SupabaseHelper - the access point for UI controllers
/// to interact with Supabase backend
final supabaseHelperProvider = Provider.autoDispose<SupabaseHelper>(
  (ref) {
    return SupabaseHelper(
      client: ref.watch(supabaseClientProvider),
    );
  },
  name: 'supabaseHelperProvider',
);
