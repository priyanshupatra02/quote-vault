import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final avatarListProvider = FutureProvider<List<FileObject>>((ref) async {
  final files = await Supabase.instance.client.storage.from('avatars').list(path: 'premade');
  return files.where((file) => file.name.endsWith('.png')).toList();
});
