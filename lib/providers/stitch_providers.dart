import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/stitch_repository.dart';

part 'stitch_providers.g.dart';

@riverpod
StitchRepository stitchRepository(Ref ref) {
  return StitchRepository();
}

@riverpod
Future<List<Category>> categories(Ref ref) async {
  final repository = ref.watch(stitchRepositoryProvider);
  return repository.getCategories();
}

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  Category? build() => null;

  void setCategory(Category? category) {
    state = category;
  }
}

@riverpod
Future<List<Product>> featuredProducts(Ref ref) async {
  final repository = ref.watch(stitchRepositoryProvider);
  return repository.getFeaturedProducts();
}

@riverpod
Future<List<Product>> filteredProducts(Ref ref) async {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final repository = ref.watch(stitchRepositoryProvider);

  if (selectedCategory == null) {
    return repository
        .getFeaturedProducts(); // Or getAllProducts if repository has it
  } else {
    // Assuming repository has a way to filter, or we filter here.
    // Let's filter here since the repository might be a mock that just returns all featured
    final products = await repository.getFeaturedProducts();
    return products.where((p) => p.categoryId == selectedCategory.id).toList();
  }
}

@riverpod
Future<Product?> product(Ref ref, String id) async {
  final repository = ref.watch(stitchRepositoryProvider);
  return repository.getProductById(id);
}
