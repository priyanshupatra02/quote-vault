import 'package:http/http.dart' as http;
import 'package:quote_vault/bootstrap.dart';

/// A custom HTTP client that logs requests and responses using Talker.
/// This mimics the functionality of TalkerDioLogger for Supabase's http usage.
class SupabaseHttpLogger extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final startTime = DateTime.now();
    try {
      // Log Request
      talker.info(
        'Supabase Request: ${request.method} ${request.url}\n'
        'Headers: ${request.headers}',
      );

      final response = await _inner.send(request);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;

      // Log Response
      talker.info(
        'Supabase Response: [${response.statusCode}] ${request.url}\n'
        'Duration: ${duration}ms',
      );

      return response;
    } catch (e, st) {
      talker.error('Supabase Request Failed', e, st);
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
