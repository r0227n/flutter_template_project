// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a singleton instance of [DatabaseService].
///
/// The database is opened at the application documents directory with
/// the filename 'todos.duckdb'. The connection is automatically closed
/// when the provider is disposed.

@ProviderFor(databaseService)
final databaseServiceProvider = DatabaseServiceProvider._();

/// Provides a singleton instance of [DatabaseService].
///
/// The database is opened at the application documents directory with
/// the filename 'todos.duckdb'. The connection is automatically closed
/// when the provider is disposed.

final class DatabaseServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<DatabaseService>,
          DatabaseService,
          FutureOr<DatabaseService>
        >
    with $FutureModifier<DatabaseService>, $FutureProvider<DatabaseService> {
  /// Provides a singleton instance of [DatabaseService].
  ///
  /// The database is opened at the application documents directory with
  /// the filename 'todos.duckdb'. The connection is automatically closed
  /// when the provider is disposed.
  DatabaseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseServiceHash();

  @$internal
  @override
  $FutureProviderElement<DatabaseService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DatabaseService> create(Ref ref) {
    return databaseService(ref);
  }
}

String _$databaseServiceHash() => r'fb974c315975a7fba84f6c704db52e916dee3f92';
