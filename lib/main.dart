import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/bootstrap.dart';
import 'package:quote_vault/core/services/notification_service.dart';
import 'package:quote_vault/shared/api_client/dio/dio_http_adapter.dart';
import 'package:quote_vault/splasher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

/// This entry point should be used for production only
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure Dio with Talker Logger
  final dio = Dio();
  if (!kReleaseMode) {
    dio.interceptors.add(
      TalkerDioLogger(
        talker: talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printRequestData: true,
          printResponseData: false, // Avoid huge logs for lists
        ),
      ),
    );
  }

  await Supabase.initialize(
    url: 'https://kmgmuyjttouitziswvyc.supabase.co',
    anonKey: 'sb_publishable_9wwh9-mlYaKOrg-frPELWw_9o3Ic1lj',
    httpClient: DioHttpAdapter(dio),
  );

  // Initialize notification service
  await NotificationService().initialize();

  runApp(
    const ProviderScope(child: Splasher()),
  );
}
