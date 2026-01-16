import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('Upload Avatars to Supabase', () async {
    // Initialize Supabase Client directly (bypassing Flutter storage init)
    final client = SupabaseClient(
      'https://kmgmuyjttouitziswvyc.supabase.co',
      'sb_publishable_9wwh9-mlYaKOrg-frPELWw_9o3Ic1lj',
    );

    final storage = client.storage;
    final bucketId = 'avatars';

    // Check if bucket exists, if not create it (requires admin/service role usually, but let's try or assume it exists)
    // Actually, creating buckets via client SDK is often restricted. We'll proceed assuming 'avatars' bucket exists
    // or is public. If this fails, user might need to create it manually or I'll use SQL.

    // Define source files
    final files = {
      'robot_1.png':
          '/Users/priyanshupatra/.gemini/antigravity/brain/54909222-f236-4e80-8446-34b32720b48c/avatar_robot_1768505057715.png',
      'cat_1.png':
          '/Users/priyanshupatra/.gemini/antigravity/brain/54909222-f236-4e80-8446-34b32720b48c/avatar_cat_1768505072237.png',
      'dog_1.png':
          '/Users/priyanshupatra/.gemini/antigravity/brain/54909222-f236-4e80-8446-34b32720b48c/avatar_dog_1768505087961.png',
      'person_1.png':
          '/Users/priyanshupatra/.gemini/antigravity/brain/54909222-f236-4e80-8446-34b32720b48c/avatar_person_1768505104060.png',
    };

    for (final entry in files.entries) {
      final fileName = entry.key;
      final filePath = entry.value;
      final file = File(filePath);

      if (!await file.exists()) {
        print('File not found: $filePath');
        continue;
      }

      try {
        final bytes = await file.readAsBytes();
        await storage.from(bucketId).uploadBinary(
              'premade/$fileName',
              bytes,
              fileOptions: const FileOptions(upsert: true, contentType: 'image/png'),
            );
        print('Uploaded $fileName successfully.');
      } catch (e) {
        print('Failed to upload $fileName: $e');
      }
    }
  });
}
