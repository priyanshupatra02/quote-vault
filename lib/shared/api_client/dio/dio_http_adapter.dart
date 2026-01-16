import 'dart:async';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

/// Adapter to allow Supabase to use Dio for network requests.
class DioHttpAdapter extends http.BaseClient {
  final Dio _dio;

  DioHttpAdapter(this._dio);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      final bytes = await request.finalize().toBytes();

      final response = await _dio.request<ResponseBody>(
        request.url.toString(),
        data: bytes.isNotEmpty ? Stream.value(bytes) : null,
        options: Options(
          method: request.method,
          headers: request.headers,
          responseType: ResponseType.stream,
        ),
      );

      return http.StreamedResponse(
        response.data!.stream.cast<List<int>>(),
        response.statusCode ?? 500,
        contentLength: response.data!.contentLength != -1 ? response.data!.contentLength : null,
        request: request,
        headers: response.headers.map.map((key, value) => MapEntry(key, value.join(','))),
        isRedirect: response.isRedirect == true,
        reasonPhrase: response.statusMessage,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw http.ClientException('Connection Timeout', request.url);
      }
      throw http.ClientException(e.message ?? 'Dio Error', request.url);
    } catch (e) {
      throw http.ClientException(e.toString(), request.url);
    }
  }

  @override
  void close() {
    // Don't close Dio here as it might be shared, or do close it if ownership is transferred.
    // For this usage, we'll keep it open or let the provider manage it.
  }
}
