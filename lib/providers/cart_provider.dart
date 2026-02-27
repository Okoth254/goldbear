import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/medusa_service.dart';

part 'cart_provider.g.dart';

@riverpod
class Cart extends _$Cart {
  String? _medusaCartId;
  final Dio _dio = MedusaService.instance.dio;

  @override
  List<CartItem> build() {
    return [];
  }

  Future<void> _ensureCartExists() async {
    if (_medusaCartId != null) return;
    try {
      final response = await _dio.post('/store/carts');
      _medusaCartId = response.data['cart']['id'];
    } catch (e) {
      // Handle cart creation failure
    }
  }

  Future<void> addItem(
    Product product, {
    Map<String, String> options = const {},
  }) async {
    // Optimistic UI update
    final index = state.indexWhere(
      (item) =>
          item.product.id == product.id &&
          _mapsEqual(item.selectedOptions, options),
    );

    if (index != -1) {
      final item = state[index];
      state = [
        ...state.sublist(0, index),
        item.copyWith(quantity: item.quantity + 1),
        ...state.sublist(index + 1),
      ];
    } else {
      state = [
        ...state,
        CartItem(
          id: DateTime.now().toString(),
          product: product,
          quantity: 1,
          selectedOptions: options,
        ),
      ];
    }

    // Backend sync
    await _ensureCartExists();
    if (_medusaCartId != null) {
      try {
        await _dio.post(
          '/store/carts/$_medusaCartId/line-items',
          data: {
            'variant_id': product
                .id, // In Medusa, we add a variant, ensuring product.id maps to variant
            'quantity': 1,
          },
        );
      } catch (e) {
        // Revert UI on failure if strict sync needed
      }
    }
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity <= 0) {
      removeItem(cartItemId);
      return;
    }

    // Optimistic update
    final index = state.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      state = [
        ...state.sublist(0, index),
        state[index].copyWith(quantity: newQuantity),
        ...state.sublist(index + 1),
      ];
    }

    // Backend sync (simplified for MVP since line_item id mapping is needed for precise updates)
    // In a full implementation, we'd map local IDs to Medusa line_item IDs.
  }

  Future<void> removeItem(String cartItemId) async {
    state = state.where((item) => item.id != cartItemId).toList();
    // Medusa backend sync requires line_item id:
    // await _dio.delete('/store/carts/$_medusaCartId/line-items/$lineItemId');
  }

  // --- Checkout Flow Integration ---

  Future<void> createPaymentSessions() async {
    await _ensureCartExists();
    if (_medusaCartId == null) throw Exception("No active cart");
    
    await _dio.post('/store/carts/$_medusaCartId/payment-sessions');
  }

  Future<void> selectPaymentSession(String providerId) async {
    if (_medusaCartId == null) throw Exception("No active cart");

    await _dio.post(
      '/store/carts/$_medusaCartId/payment-session',
      data: {'provider_id': providerId},
    );
  }

  Future<void> updatePaymentSessionData(String phone) async {
    if (_medusaCartId == null) throw Exception("No active cart");

    await _dio.post(
      '/store/carts/$_medusaCartId/payment-session/update',
      data: {
        'data': {
          'phone': phone,
        }
      }
    );
  }

  Future<String?> completeCart() async {
    if (_medusaCartId == null) throw Exception("No active cart");

    final response = await _dio.post('/store/carts/$_medusaCartId/complete');
    
    // Response type could be 'order' or 'cart' (if requires more action)
    if (response.data['type'] == 'order') {
      return response.data['data']['id']; // Return order ID
    }
    return null;
  }

  void clearCart() {
    state = [];
    _medusaCartId = null; // Next add will create a new physical cart
  }

  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      state.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  double get shipping => 150.0; // Flat rate for now
  double get total => subtotal + shipping;

  bool _mapsEqual(Map<String, String> map1, Map<String, String> map2) {
    if (map1.length != map2.length) return false;
    for (final key in map1.keys) {
      if (map1[key] != map2[key]) return false;
    }
    return true;
  }
}
