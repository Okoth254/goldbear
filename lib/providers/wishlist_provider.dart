import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../models/product.dart';
import '../services/medusa_service.dart';

part 'wishlist_provider.g.dart';

@riverpod
class Wishlist extends _$Wishlist {
  final Dio _dio = MedusaService.instance.dio;

  @override
  FutureOr<List<Product>> build() async {
    return _fetchWishlist();
  }

  Future<List<Product>> _fetchWishlist() async {
    try {
      final response = await _dio.get('/store/customers/me');
      final metadata = response.data['customer']['metadata'] ?? {};
      final savedIds = List<String>.from(metadata['wishlist'] ?? []);

      if (savedIds.isEmpty) return [];

      // Fetch actual products for these IDs
      final List<Product> products = [];
      for (String id in savedIds) {
        try {
          final prodRes = await _dio.get('/store/products/$id');
          final json = prodRes.data['product'];

          final variants = json['variants'] as List?;
          final priceObj = variants?.isNotEmpty == true
              ? (variants!.first['prices'] as List?)?.first
              : null;
          final double amount = (priceObj?['amount'] ?? 0) / 100.0;

          products.add(
            Product(
              id: json['id'],
              name: json['title'],
              description: json['description'] ?? '',
              price: amount,
              imageUrl: json['thumbnail'] ?? '',
              categoryId: json['collection_id'] ?? '',
            ),
          );
        } catch (e) {
          // Ignore failures for individual products
        }
      }
      return products;
    } catch (e) {
      return [];
    }
  }

  Future<void> toggleItem(Product product) async {
    final currentList = state.value ?? [];
    List<Product> newList;

    if (currentList.any((p) => p.id == product.id)) {
      newList = currentList.where((p) => p.id != product.id).toList();
    } else {
      newList = [...currentList, product];
    }

    // Optimistic UI update
    state = AsyncValue.data(newList);

    // Sync to backend
    await _syncToMedusa(newList.map((p) => p.id).toList());
  }

  Future<void> removeItem(String productId) async {
    final currentList = state.value ?? [];
    final newList = currentList.where((p) => p.id != productId).toList();

    state = AsyncValue.data(newList);
    await _syncToMedusa(newList.map((p) => p.id).toList());
  }

  Future<void> clearWishlist() async {
    state = const AsyncValue.data([]);
    await _syncToMedusa([]);
  }

  bool isInWishlist(String productId) {
    return state.value?.any((p) => p.id == productId) ?? false;
  }

  Future<void> _syncToMedusa(List<String> productIds) async {
    try {
      // First get current metadata to merge it
      final response = await _dio.get('/store/customers/me');
      final metadata = Map<String, dynamic>.from(
        response.data['customer']['metadata'] ?? {},
      );

      metadata['wishlist'] = productIds;

      await _dio.post('/store/customers/me', data: {'metadata': metadata});
    } catch (e) {
      // Background sync failed
    }
  }
}
