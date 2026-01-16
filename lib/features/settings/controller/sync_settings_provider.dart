import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final syncSettingsProvider =
    AsyncNotifierProvider<SyncSettingsNotifier, bool>(() => SyncSettingsNotifier());

class SyncSettingsNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('cloud_sync_enabled') ?? true;
  }

  Future<void> updateSync(bool value) async {
    // Optimistically update state? Or waiting is fine.
    // For sync toggle, instant feedback is better, but this IS sync.
    // Let's just do standard request.
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('cloud_sync_enabled', value);
      return value;
    });
  }
}
