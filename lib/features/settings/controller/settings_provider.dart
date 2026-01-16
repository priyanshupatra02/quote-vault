import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/local_storage/app_storage.dart';
import 'package:quote_vault/core/local_storage/app_storage_pod.dart';
import 'package:quote_vault/data/network/supabase_helper.dart';
import 'package:quote_vault/data/network/supabase_helper_pod.dart';

class FontSizeNotifier extends StateNotifier<double> {
  final AppStorage appStorage;
  final SupabaseHelper supabaseHelper;

  FontSizeNotifier({
    required this.appStorage,
    required this.supabaseHelper,
  }) : super(50.0) {
    _init();
  }

  void _init() {
    final storedValue = appStorage.get(key: 'font_size');
    if (storedValue != null) {
      state = double.tryParse(storedValue) ?? 50.0;
    }
  }

  Future<void> setFontSize(double value) async {
    state = value;
    // Persist locally
    await appStorage.put(key: 'font_size', value: value.toString());

    // Sync remotely (fire and forget)
    final user = supabaseHelper.client.auth.currentUser;
    if (user != null) {
      try {
        await supabaseHelper.updateProfile(
          userId: user.id,
          fontSize: value,
        );
      } catch (e) {
        // Silently fail if sync fails (e.g. offline or no column)
        // Local persistence is robust enough.
      }
    }
  }
}

final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  return FontSizeNotifier(
    appStorage: ref.watch(appStorageProvider),
    supabaseHelper: ref.watch(supabaseHelperProvider),
  );
});
