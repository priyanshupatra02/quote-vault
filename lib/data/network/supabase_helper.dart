import 'package:multiple_result/multiple_result.dart';
import 'package:quote_vault/data/model/category_model.dart';
import 'package:quote_vault/data/model/collection_model.dart';
import 'package:quote_vault/data/model/profile_model.dart';
import 'package:quote_vault/data/model/quote_model.dart';
import 'package:quote_vault/data/model/user_favorite_model.dart';
import 'package:quote_vault/shared/exception/base_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// SupabaseHelper - Central API helper for all Supabase operations
/// Following the same pattern as ApiHelper in eduinfitium_student_flutter
class SupabaseHelper {
  final SupabaseClient client;

  SupabaseHelper({required this.client});

  // ============ AUTH METHODS ============

  /// Sign up with email and password
  Future<Result<User, APIException>> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );

      if (response.user != null) {
        // Create profile entry
        if (name != null) {
          await client.from('profiles').upsert({
            'id': response.user!.id,
            'name': name,
          });
        }
        return Success(response.user!);
      } else {
        return Error(APIException(errorMessage: 'Sign up failed. Please try again.'));
      }
    } on AuthException catch (e) {
      return Error(APIException(
          errorMessage: e.message,
          statusCode: e.statusCode != null ? int.tryParse(e.statusCode!) : null));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Sign in with email and password
  Future<Result<User, APIException>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return Success(response.user!);
      } else {
        return Error(APIException(errorMessage: 'Sign in failed. Please check your credentials.'));
      }
    } on AuthException catch (e) {
      return Error(APIException(
          errorMessage: e.message,
          statusCode: e.statusCode != null ? int.tryParse(e.statusCode!) : null));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Sign out
  Future<Result<void, APIException>> signOut() async {
    try {
      await client.auth.signOut();
      return const Success(null);
    } on AuthException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Reset password
  Future<Result<void, APIException>> resetPassword({required String email}) async {
    try {
      await client.auth.resetPasswordForEmail(email);
      return const Success(null);
    } on AuthException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  // ============ PROFILE METHODS ============

  /// Get user profile
  Future<Result<ProfileModel, APIException>> getProfile({required String userId}) async {
    try {
      final response = await client.from('profiles').select().eq('id', userId).single();

      return Success(ProfileModel.fromMap(response));
    } on PostgrestException catch (e) {
      return Error(APIException(
          errorMessage: e.message, statusCode: e.code != null ? int.tryParse(e.code!) : null));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Update user profile
  Future<Result<ProfileModel, APIException>> updateProfile({
    required String userId,
    String? name,
    String? avatarUrl,
    double? fontSize,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (name != null) updates['name'] = name;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (fontSize != null) updates['font_size'] = fontSize;

      final response =
          await client.from('profiles').update(updates).eq('id', userId).select().single();

      return Success(ProfileModel.fromMap(response));
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Update notification preferences
  Future<Result<ProfileModel, APIException>> updateNotificationPreferences({
    required String userId,
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    try {
      final updates = <String, dynamic>{
        'notification_enabled': enabled,
        'notification_hour': hour,
        'notification_minute': minute,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response =
          await client.from('profiles').update(updates).eq('id', userId).select().single();

      return Success(ProfileModel.fromMap(response));
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Update login streak
  Future<Result<ProfileModel, APIException>> updateLoginStreak({
    required String userId,
  }) async {
    try {
      // Get current profile
      final currentProfileResult = await getProfile(userId: userId);
      ProfileModel currentProfile;

      if (currentProfileResult.isSuccess()) {
        currentProfile = currentProfileResult.tryGetSuccess()!;
      } else {
        return Error(currentProfileResult.tryGetError()!);
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final todayString = today.toIso8601String();

      // Check last login date
      int newStreak = 1;
      if (currentProfile.lastLoginDate != null) {
        final lastLoginFn = DateTime.parse(currentProfile.lastLoginDate!);
        final lastLogin = DateTime(lastLoginFn.year, lastLoginFn.month, lastLoginFn.day);

        final difference = today.difference(lastLogin).inDays;

        if (difference == 0) {
          // Already logged in today, return current profile
          return Success(currentProfile);
        } else if (difference == 1) {
          // Consecutive day, increment streak
          newStreak = currentProfile.loginStreak + 1;
        } else {
          // Missed a day or more, reset to 1
          newStreak = 1;
        }
      }

      final updates = <String, dynamic>{
        'login_streak': newStreak,
        'last_login_date': todayString,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response =
          await client.from('profiles').update(updates).eq('id', userId).select().single();

      return Success(ProfileModel.fromMap(response));
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Increment share count
  Future<Result<ProfileModel, APIException>> incrementShareCount({
    required String userId,
  }) async {
    try {
      // Get current profile
      final currentProfileResult = await getProfile(userId: userId);
      int currentShareCount = 0;

      if (currentProfileResult.isSuccess()) {
        currentShareCount = currentProfileResult.tryGetSuccess()!.shareCount;
      }

      final updates = <String, dynamic>{
        'share_count': currentShareCount + 1,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response =
          await client.from('profiles').update(updates).eq('id', userId).select().single();

      return Success(ProfileModel.fromMap(response));
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Get random quotes for notification scheduling
  Future<Result<List<QuoteModel>, APIException>> getRandomQuotes({required int count}) async {
    try {
      // Use PostgreSQL random() function to get random quotes
      final response = await client
          .from('quotes')
          .select('*, categories(*)')
          .limit(count * 3) // Fetch more to ensure variety
          .order('id', ascending: true);

      final quotes = (response as List).map((e) => QuoteModel.fromMap(e)).toList();

      // Shuffle and take the required count
      quotes.shuffle();
      final selectedQuotes = quotes.take(count).toList();

      return Success(selectedQuotes);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  // ============ CATEGORY METHODS ============

  /// Get all categories
  Future<Result<List<CategoryModel>, APIException>> getCategories() async {
    try {
      final response = await client.from('categories').select().order('name');

      final categories = (response as List).map((e) => CategoryModel.fromMap(e)).toList();

      return Success(categories);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  // ============ QUOTE METHODS ============

  /// Get total quotes count
  Future<Result<int, APIException>> getQuotesCount() async {
    try {
      final count = await client.from('quotes').count(CountOption.exact);

      return Success(count);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Get quotes with pagination
  Future<Result<List<QuoteModel>, APIException>> getQuotes({
    int page = 0,
    int pageSize = 20,
    int? categoryId,
    String? searchQuery,
    int offset = 0,
  }) async {
    try {
      var query = client.from('quotes').select('*, categories(*)');

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or('content.ilike.%$searchQuery%,author.ilike.%$searchQuery%');
      }

      final start = offset + (page * pageSize);
      final response =
          await query.order('created_at', ascending: false).range(start, start + pageSize - 1);

      final quotes = (response as List).map((e) => QuoteModel.fromMap(e)).toList();

      return Success(quotes);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Get single quote by ID
  Future<Result<QuoteModel, APIException>> getQuoteById({required int quoteId}) async {
    try {
      final response =
          await client.from('quotes').select('*, categories(*)').eq('id', quoteId).single();

      return Success(QuoteModel.fromMap(response));
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Get daily quote
  Future<Result<QuoteModel, APIException>> getDailyQuote() async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      // Try to get today's daily quote
      final dailyQuoteResponse =
          await client.from('daily_quotes').select('quote_id').eq('date', today).maybeSingle();

      if (dailyQuoteResponse != null) {
        return getQuoteById(quoteId: dailyQuoteResponse['quote_id']);
      }

      // If no daily quote set, get a random quote
      final randomQuote = await client
          .from('quotes')
          .select('*, categories(*)')
          .limit(1)
          .order('id', ascending: false);

      if ((randomQuote as List).isNotEmpty) {
        return Success(QuoteModel.fromMap(randomQuote.first));
      }

      return Error(APIException(errorMessage: 'No quotes available'));
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Search quotes
  Future<Result<List<QuoteModel>, APIException>> searchQuotes({
    required String query,
    int limit = 20,
  }) async {
    try {
      final response = await client
          .from('quotes')
          .select('*, categories(*)')
          .or('content.ilike.%$query%,author.ilike.%$query%')
          .limit(limit);

      final quotes = (response as List).map((e) => QuoteModel.fromMap(e)).toList();

      return Success(quotes);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  // ============ FAVORITES METHODS ============

  /// Get user's favorite quotes
  Future<Result<List<QuoteModel>, APIException>> getFavorites({
    required String userId,
  }) async {
    try {
      final response = await client
          .from('user_favorites')
          .select('quote_id, quotes(*, categories(*))')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final quotes = (response as List).map((e) => QuoteModel.fromMap(e['quotes'])).toList();

      return Success(quotes);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Add quote to favorites
  Future<Result<UserFavoriteModel, APIException>> addToFavorites({
    required String userId,
    required int quoteId,
  }) async {
    try {
      final response = await client
          .from('user_favorites')
          .insert({
            'user_id': userId,
            'quote_id': quoteId,
          })
          .select()
          .single();

      return Success(UserFavoriteModel.fromMap(response));
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Remove quote from favorites
  Future<Result<void, APIException>> removeFromFavorites({
    required String userId,
    required int quoteId,
  }) async {
    try {
      await client.from('user_favorites').delete().eq('user_id', userId).eq('quote_id', quoteId);

      return const Success(null);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Check if quote is favorited
  Future<Result<bool, APIException>> isFavorite({
    required String userId,
    required int quoteId,
  }) async {
    try {
      final response = await client
          .from('user_favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('quote_id', quoteId)
          .maybeSingle();

      return Success(response != null);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  // ============ COLLECTION METHODS ============

  /// Get user's collections
  Future<Result<List<CollectionModel>, APIException>> getCollections({
    required String userId,
  }) async {
    try {
      final response = await client
          .from('collections')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final collections = (response as List).map((e) => CollectionModel.fromMap(e)).toList();

      return Success(collections);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Create collection
  Future<Result<CollectionModel, APIException>> createCollection({
    required String userId,
    required String name,
    String? iconName,
  }) async {
    try {
      final response = await client
          .from('collections')
          .insert({
            'user_id': userId,
            'name': name,
            'icon_name': iconName,
          })
          .select()
          .single();

      return Success(CollectionModel.fromMap(response));
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Delete collection
  Future<Result<void, APIException>> deleteCollection({
    required int collectionId,
  }) async {
    try {
      await client.from('collections').delete().eq('id', collectionId);

      return const Success(null);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Get quotes in collection
  Future<Result<List<QuoteModel>, APIException>> getCollectionQuotes({
    required int collectionId,
  }) async {
    try {
      final response = await client
          .from('collection_quotes')
          .select('quote_id, quotes(*, categories(*))')
          .eq('collection_id', collectionId)
          .order('created_at', ascending: false);

      final quotes = (response as List).map((e) => QuoteModel.fromMap(e['quotes'])).toList();

      return Success(quotes);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Add quote to collection
  Future<Result<void, APIException>> addToCollection({
    required int collectionId,
    required int quoteId,
  }) async {
    try {
      await client.from('collection_quotes').insert({
        'collection_id': collectionId,
        'quote_id': quoteId,
      });

      return const Success(null);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }

  /// Remove quote from collection
  Future<Result<void, APIException>> removeFromCollection({
    required int collectionId,
    required int quoteId,
  }) async {
    try {
      await client
          .from('collection_quotes')
          .delete()
          .eq('collection_id', collectionId)
          .eq('quote_id', quoteId);

      return const Success(null);
    } on PostgrestException catch (e) {
      return Error(APIException(errorMessage: e.message));
    } catch (e) {
      return Error(APIException(errorMessage: e.toString()));
    }
  }
}
