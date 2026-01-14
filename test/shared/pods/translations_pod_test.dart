import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quote_vault/shared/pods/translation_pod.dart';

void main() {
  test('translationsPod throws UnimplementedError when not overridden', () {
    final container = ProviderContainer();

    expect(
      () => container.read(translationsPod),
      throwsA(isA<UnimplementedError>()),
    );
  });
}
