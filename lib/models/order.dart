import 'package:freezed_annotation/freezed_annotation.dart';
import 'cart_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
sealed class Order with _$Order {
  const factory Order({
    required String id,
    required List<CartItem> items,
    required double total,
    required String status,
    required DateTime date,
    @Default('M-Pesa') String paymentMethod,
    @Default('123 Riverside Drive, Nairobi') String shippingAddress,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
