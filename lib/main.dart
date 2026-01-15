import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/splasher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// This entry point should be used for production only
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kmgmuyjttouitziswvyc.supabase.co',
    anonKey: 'sb_publishable_9wwh9-mlYaKOrg-frPELWw_9o3Ic1lj',
  );

  runApp(
    const ProviderScope(child: Splasher()),
  );
}
