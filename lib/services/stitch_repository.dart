import '../models/product.dart';
import '../models/category.dart';
import 'medusa_service.dart';
import 'package:dio/dio.dart';
// For IconData if needed, but models should be pure.
// Actually, the current Home Screen uses IconData for categories.
// I should probably map strings to Icons in the UI or use an Enum,
// as "IconData" is not serializable from a real API.
// For this binding, I'll use String identifiers for icons.

class StitchRepository {
  final Dio _dio = MedusaService.instance.dio;

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/store/collections');
      final collections = response.data['collections'] as List;

      return collections.map((json) {
        return Category(
          id: json['id'],
          name: json['title'], // Medusa calls it title
          // Medusa collections don't natively have thumbnails out-of-the-box in v1.x often,
          // but we can map metadata or use a placeholder if missing.
          imageUrl:
              json['metadata']?['image_url'] ??
              'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=400&q=80',
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<List<Product>> getFeaturedProducts() async {
    try {
      final response = await _dio.get('/store/products');
      final products = response.data['products'] as List;

      return products.map((json) {
        final variants = json['variants'] as List?;
        final priceObj = variants?.isNotEmpty == true
            ? (variants!.first['prices'] as List?)?.first
            : null;

        final double amount =
            (priceObj?['amount'] ?? 0) / 100.0; // Medusa stores in cents

        return Product(
          id: json['id'],
          name: json['title'],
          description: json['description'] ?? '',
          price: amount,
          imageUrl:
              json['thumbnail'] ??
              'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=600&q=80',
          categoryId: json['collection_id'] ?? '',
          // Extract options from Medusa variants into specs map
          specs: _extractSpecs(json),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      final response = await _dio.get('/store/products/$id');
      final json = response.data['product'];

      final variants = json['variants'] as List?;
      final priceObj = variants?.isNotEmpty == true
          ? (variants!.first['prices'] as List?)?.first
          : null;

      final double amount = (priceObj?['amount'] ?? 0) / 100.0;

      return Product(
        id: json['id'],
        name: json['title'],
        description: json['description'] ?? '',
        price: amount,
        imageUrl:
            json['thumbnail'] ??
            'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=600&q=80',
        categoryId: json['collection_id'] ?? '',
        specs: _extractSpecs(json),
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, String> _extractSpecs(Map<String, dynamic> productJson) {
    final specs = <String, String>{};
    final options = productJson['options'] as List?;
    if (options != null) {
      for (var opt in options) {
        final title = opt['title'] as String;
        // Just taking the first available value for simplicity in specs display
        final values = opt['values'] as List?;
        if (values != null && values.isNotEmpty) {
          specs[title] = values.first['value'].toString();
        }
      }
    }
    return specs;
  }
}
