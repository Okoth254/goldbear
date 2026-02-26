import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

part 'orders_provider.g.dart';

@riverpod
class Orders extends _$Orders {
  @override
  List<Order> build() {
    return [
      // Mock initial orders
      // In a real app, this would be empty or fetched from API
    ];
  }

  Order addOrder(
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
    state = [order, ...state];
    return order;
  }

  Order? getOrderById(String id) {
    try {
      return state.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }
}
