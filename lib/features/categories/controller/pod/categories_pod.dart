import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/features/categories/controller/notifier/categories_notifier.dart';
import 'package:quote_vault/features/categories/controller/state/categories_states.dart';

/// Provider for categories state
final categoriesProvider = AsyncNotifierProvider.autoDispose<CategoriesNotifier, CategoriesState>(
  CategoriesNotifier.new,
  name: 'categoriesProvider',
);
