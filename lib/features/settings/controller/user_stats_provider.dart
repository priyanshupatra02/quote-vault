import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/data/model/profile_model.dart';
import 'package:quote_vault/data/network/supabase_helper.dart';
import 'package:quote_vault/data/network/supabase_helper_pod.dart';
import 'package:quote_vault/features/auth/controller/auth_controller.dart';

class UserStatsNotifier extends StateNotifier<AsyncValue<ProfileModel?>> {
  final SupabaseHelper _supabaseHelper;
  final String? _userId;

  UserStatsNotifier(this._supabaseHelper, this._userId) : super(const AsyncValue.loading()) {
    if (_userId != null) {
      _initStats();
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> _initStats() async {
    try {
      // Update login streak which also returns the updated profile
      final result = await _supabaseHelper.updateLoginStreak(userId: _userId!);

      result.when(
        (profile) => state = AsyncValue.data(profile),
        (error) => state = AsyncValue.error(error, StackTrace.current),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> incrementShare() async {
    if (_userId == null) return;

    // Optimistic update
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncValue.data(currentState.copyWith(
        shareCount: currentState.shareCount + 1,
      ));
    }

    try {
      final result = await _supabaseHelper.incrementShareCount(userId: _userId!);
      result.when(
        (profile) => state = AsyncValue.data(profile),
        (error) {
          // Revert on error if needed, or just log
          // For now, we trust the next fetch or ignore
        },
      );
    } catch (e) {
      // Ignore
    }
  }
}

final userStatsProvider =
    StateNotifierProvider<UserStatsNotifier, AsyncValue<ProfileModel?>>((ref) {
  final supabaseHelper = ref.watch(supabaseHelperProvider);
  final userState = ref.watch(authControllerProvider);
  final userId = userState.value?.id;

  return UserStatsNotifier(supabaseHelper, userId);
});
