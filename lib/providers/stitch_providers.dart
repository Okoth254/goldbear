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
Future<List<Product>> featuredProducts(Ref ref) async {
  final repository = ref.watch(stitchRepositoryProvider);
  return repository.getFeaturedProducts();
}

@riverpod
Future<Product?> product(Ref ref, String id) async {
  final repository = ref.watch(stitchRepositoryProvider);
  return repository.getProductById(id);
}
