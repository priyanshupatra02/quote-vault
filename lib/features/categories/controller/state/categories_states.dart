import 'package:quote_vault/data/model/category_model.dart';

/// Sealed class for categories state management
sealed class CategoriesState {
  const CategoriesState();
}

/// Initial state
class CategoriesInitialState implements CategoriesState {
  const CategoriesInitialState();
}

/// Loading state
class CategoriesLoadingState implements CategoriesState {
  const CategoriesLoadingState();
}

/// Categories loaded successfully
class CategoriesLoadedState implements CategoriesState {
  final List<CategoryModel> categories;

  const CategoriesLoadedState({required this.categories});
}

/// Error state
class CategoriesErrorState implements CategoriesState {
  final String message;

  const CategoriesErrorState({required this.message});
}
