// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stitch_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stitchRepository)
final stitchRepositoryProvider = StitchRepositoryProvider._();

final class StitchRepositoryProvider
    extends
        $FunctionalProvider<
          StitchRepository,
          StitchRepository,
          StitchRepository
        >
    with $Provider<StitchRepository> {
  StitchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stitchRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stitchRepositoryHash();

  @$internal
  @override
  $ProviderElement<StitchRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StitchRepository create(Ref ref) {
    return stitchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StitchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StitchRepository>(value),
    );
  }
}

String _$stitchRepositoryHash() => r'827e6aba750ef29200060836fa84b3f34cc2d5e4';

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
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

String _$categoriesHash() => r'1f137f5768d422ccff7c3628be842ab30e0ae84c';

@ProviderFor(featuredProducts)
final featuredProductsProvider = FeaturedProductsProvider._();

final class FeaturedProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  FeaturedProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featuredProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featuredProductsHash();

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    return featuredProducts(ref);
  }
}

String _$featuredProductsHash() => r'716d9a13ce8ad5a8bc8d863fb91c4545735644b6';

@ProviderFor(product)
final productProvider = ProductFamily._();

final class ProductProvider
    extends
        $FunctionalProvider<AsyncValue<Product?>, Product?, FutureOr<Product?>>
    with $FutureModifier<Product?>, $FutureProvider<Product?> {
  ProductProvider._({
    required ProductFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productHash();

  @override
  String toString() {
    return r'productProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Product?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Product?> create(Ref ref) {
    final argument = this.argument as String;
    return product(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productHash() => r'0216bda646837a94c26c89320f84f57d46aa9009';

final class ProductFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Product?>, String> {
  ProductFamily._()
    : super(
        retry: null,
        name: r'productProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductProvider call(String id) =>
      ProductProvider._(argument: id, from: this);

  @override
  String toString() => r'productProvider';
}
