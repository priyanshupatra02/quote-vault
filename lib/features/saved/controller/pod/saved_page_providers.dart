import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Filter tabs for the vault
enum VaultFilter { all, favorites, collections }

/// Provider for the selected vault filter tab
final vaultFilterProvider = StateProvider<VaultFilter>((ref) => VaultFilter.all);

/// Provider for search mode state
final vaultSearchModeProvider = StateProvider<bool>((ref) => false);

/// Provider for search query text
final vaultSearchQueryProvider = StateProvider<String>((ref) => '');
