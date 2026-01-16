import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/data/network/supabase_helper_pod.dart';
import 'package:quote_vault/features/categories/controller/state/categories_states.dart';

/// Categories notifier for fetching categories from Supabase
class CategoriesNotifier extends AutoDisposeAsyncNotifier<CategoriesState> {
  @override
  FutureOr<CategoriesState> build() async {
    final result = await ref.read(supabaseHelperProvider).getCategories();

    return result.when(
      (categories) => CategoriesLoadedState(categories: categories),
      (error) => CategoriesErrorState(message: error.errorMessage),
    );
  }

  Future<void> refresh() async {
    state = const AsyncData(CategoriesLoadingState());

    final result = await ref.read(supabaseHelperProvider).getCategories();

    state = AsyncData(result.when(
      (categories) => CategoriesLoadedState(categories: categories),
      (error) => CategoriesErrorState(message: error.errorMessage),
    ));
  }
}
