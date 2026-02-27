import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/medusa_service.dart';

part 'orders_provider.g.dart';

@riverpod
class Orders extends _$Orders {
  final Dio _dio = MedusaService.instance.dio;

  @override
  FutureOr<List<Order>> build() async {
    return _fetchOrders();
  }

  Future<List<Order>> _fetchOrders() async {
    try {
      final response = await _dio.get('/store/customers/me/orders');
      final ordersJson = response.data['orders'] as List;

      return ordersJson.map((json) {
        final itemsJson = json['items'] as List;
        final items = itemsJson.map((item) {
          return CartItem(
            id: item['id'],
            quantity: item['quantity'],
            product: Product(
              id: item['variant_id'] ?? item['id'],
              name: item['title'],
              description: item['description'] ?? '',
              price: (item['unit_price'] ?? 0) / 100.0,
              imageUrl: item['thumbnail'] ?? '',
              categoryId: '',
            ),
            selectedOptions: {},
          );
        }).toList();

        return Order(
          id: json['display_id']
              .toString(), // Medusa uses display_id for human readable #
          items: items,
          total: (json['total'] ?? 0) / 100.0,
          status: json['status'] ?? 'pending',
          date: DateTime.parse(json['created_at']),
          paymentMethod: 'Card / Medusa Pay', // Default
        );
      }).toList();
    } catch (e) {
      // If not logged in or error, return empty
      return [];
    }
  }

  // Simplified local add for instant UI feedback after checkout before full reload
  Order addPromisedOrder(
    List<CartItem> items,
    double total, {
    String paymentMethod = 'M-Pesa',
    String shippingAddress = '123 Riverside Drive, Nairobi',
  }) {
    final order = Order(
      id: '#ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: items,
      total: total,
      status: 'Processing',
      date: DateTime.now(),
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress,
    );

    final currentOrders = state.value ?? [];
    state = AsyncValue.data([order, ...currentOrders]);
    return order;
  }

  Order? getOrderById(String id) {
    try {
      return state.value?.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }
}
