import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/local_storage/app_storage_pod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';

final themeColorControllerProvider = NotifierProvider.autoDispose<ThemeColorController, Color>(
  ThemeColorController.new,
  name: 'themeColorControllerProvider',
);

class ThemeColorController extends AutoDisposeNotifier<Color> {
  final _colorKey = "accent_color";

  @override
  Color build() {
    final colorValue = ref.watch(appStorageProvider).get(key: _colorKey);
    if (colorValue != null) {
      return Color(int.parse(colorValue));
    }
    return AppColors.primary;
  }

  Future<void> changeColor(Color color) async {
    state = color;
    await ref.read(appStorageProvider).put(key: _colorKey, value: color.value.toString());
  }
}
