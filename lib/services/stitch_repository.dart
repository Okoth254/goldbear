import '../models/product.dart';
import '../models/category.dart';
// For IconData if needed, but models should be pure.
// Actually, the current Home Screen uses IconData for categories.
// I should probably map strings to Icons in the UI or use an Enum,
// as "IconData" is not serializable from a real API.
// For this binding, I'll use String identifiers for icons.

class StitchRepository {
  // Simulating fetching data for the 'Home' screen (Stitch ID: 7f35f249a...)
  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    return [
      const Category(
        id: 'cat_1',
        name: 'Living Room',
        imageUrl: 'assets/icons/sofa.svg',
      ), // Placeholder image logic
      const Category(
        id: 'cat_2',
        name: 'Bedroom',
        imageUrl: 'assets/icons/bed.svg',
      ),
      const Category(
        id: 'cat_3',
        name: 'Dining',
        imageUrl: 'assets/icons/dining.svg',
      ),
      const Category(
        id: 'cat_4',
        name: 'Office',
        imageUrl: 'assets/icons/office.svg',
      ),
      const Category(
        id: 'cat_5',
        name: 'Outdoor',
        imageUrl: 'assets/icons/outdoor.svg',
      ),
    ];
  }

  // Simulating fetching data for the 'Home' screen products
  Future<List<Product>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      const Product(
        id: 'prod_1',
        name: 'Obsidian Lounge Chair',
        description: 'A masterpiece of comfort and style.',
        price: 2450.0,
        imageUrl:
            'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=600&q=80',
        categoryId: 'cat_1',
        isNew: true,
        specs: {'Material': 'Leather', 'Wood': 'Walnut'},
      ),
      const Product(
        id: 'prod_2',
        name: 'Noir Side Table',
        description: 'Elegant side table with matte finish.',
        price: 450.0,
        imageUrl:
            'https://images.unsplash.com/photo-1618220179428-22790b461013?auto=format&fit=crop&w=600&q=80',
        categoryId: 'cat_1',
        isNew: false,
      ),
      const Product(
        id: 'prod_3',
        name: 'Alpaca Throw',
        description: 'Softest throw for your couch.',
        price: 180.0,
        imageUrl:
            'https://images.unsplash.com/photo-1580587771525-78b9dba3b91d?auto=format&fit=crop&w=600&q=80',
        categoryId: 'cat_1',
        specs: {'Material': 'Alpaca Wool'},
      ),
    ];
  }

  Future<Product?> getProductById(String id) async {
    final products = await getFeaturedProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
