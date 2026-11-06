import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/dependencies/observability_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('required tokens fail immediately without a composition root', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(
      () => container.read(appPreferencesUseCaseProvider),
      throwsA(anything),
    );
    expect(
      () => container.read(initialAppPreferencesSnapshotProvider),
      throwsA(anything),
    );
    expect(() => container.read(errorReporterProvider), throwsA(anything));
  });
}
