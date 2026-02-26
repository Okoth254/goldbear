import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

part 'cart_provider.g.dart';

@riverpod
class Cart extends _$Cart {
  @override
  List<CartItem> build() {
    return [];
  }

  void addItem(Product product, {Map<String, String> options = const {}}) {
    // Check if item already exists with option
    final index = state.indexWhere(
      (item) =>
          item.product.id == product.id &&
          _mapsEqual(item.selectedOptions, options),
    );

    if (index != -1) {
      // Update quantity
      final item = state[index];
      state = [
        ...state.sublist(0, index),
        item.copyWith(quantity: item.quantity + 1),
        ...state.sublist(index + 1),
      ];
    } else {
      // Add new
      state = [
        ...state,
        CartItem(
          id: DateTime.now().toString(), // Simple ID generation
          product: product,
          quantity: 1,
          selectedOptions: options,
        ),
      ];
    }
  }

  void updateQuantity(String cartItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(cartItemId);
      return;
    }
    final index = state.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      state = [
        ...state.sublist(0, index),
        state[index].copyWith(quantity: newQuantity),
        ...state.sublist(index + 1),
      ];
    }
  }

  void removeItem(String cartItemId) {
    state = state.where((item) => item.id != cartItemId).toList();
  }

  void clearCart() {
    state = [];
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
