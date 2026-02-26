// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toDouble(),
  status: json['status'] as String,
  date: DateTime.parse(json['date'] as String),
  paymentMethod: json['paymentMethod'] as String? ?? 'M-Pesa',
  shippingAddress:
      json['shippingAddress'] as String? ?? '123 Riverside Drive, Nairobi',
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'items': instance.items,
  'total': instance.total,
  'status': instance.status,
  'date': instance.date.toIso8601String(),
  'paymentMethod': instance.paymentMethod,
  'shippingAddress': instance.shippingAddress,
};
