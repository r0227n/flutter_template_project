// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides an instance of [CategoryRepository].
///
/// The repository is created with the database service
/// from [databaseServiceProvider].

@ProviderFor(categoryRepository)
final categoryRepositoryProvider = CategoryRepositoryProvider._();

/// Provides an instance of [CategoryRepository].
///
/// The repository is created with the database service
/// from [databaseServiceProvider].

final class CategoryRepositoryProvider
    extends
        $FunctionalProvider<
          CategoryRepository,
          CategoryRepository,
          CategoryRepository
        >
    with $Provider<CategoryRepository> {
  /// Provides an instance of [CategoryRepository].
  ///
  /// The repository is created with the database service
  /// from [databaseServiceProvider].
  CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRepository create(Ref ref) {
    return categoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRepository>(value),
    );
  }
}

String _$categoryRepositoryHash() =>
    r'ee5f2c2e0c83aee5bf382d96bdb776c0a102a9ea';

/// Provides a list of all categories.
///
/// The list is automatically updated when categories are modified.

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

/// Provides a list of all categories.
///
/// The list is automatically updated when categories are modified.

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  /// Provides a list of all categories.
  ///
  /// The list is automatically updated when categories are modified.
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'd3d0d7a00a258f61085ce48acb094253ec11d129';

/// Provides a single category by its [id].
///
/// Returns null if the category doesn't exist.

@ProviderFor(categoryDetail)
final categoryDetailProvider = CategoryDetailFamily._();

/// Provides a single category by its [id].
///
/// Returns null if the category doesn't exist.

final class CategoryDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<Category?>,
          Category?,
          FutureOr<Category?>
        >
    with $FutureModifier<Category?>, $FutureProvider<Category?> {
  /// Provides a single category by its [id].
  ///
  /// Returns null if the category doesn't exist.
  CategoryDetailProvider._({
    required CategoryDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'categoryDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryDetailHash();

  @override
  String toString() {
    return r'categoryDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Category?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Category?> create(Ref ref) {
    final argument = this.argument as String;
    return categoryDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryDetailHash() => r'9a4e13727fd4e336b4ef6123f59c2f9b87d7bfe6';

/// Provides a single category by its [id].
///
/// Returns null if the category doesn't exist.

final class CategoryDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Category?>, String> {
  CategoryDetailFamily._()
    : super(
        retry: null,
        name: r'categoryDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides a single category by its [id].
  ///
  /// Returns null if the category doesn't exist.

  CategoryDetailProvider call(String id) =>
      CategoryDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'categoryDetailProvider';
}
