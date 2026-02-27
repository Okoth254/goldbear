import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../providers/orders_provider.dart';
import '../models/cart_item.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We can't use getOrderById efficiently in build if we want reactivity on the list.
    // Instead, watch the list and find the item.
    final orders = ref.watch(ordersProvider);
    return orders.when(
      loading: () => const Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          title: const Text('Order Details'),
          backgroundColor: AppTheme.backgroundLight,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(child: Text('Error loading order: $error')),
      ),
      data: (orderList) {
        final order = orderList.firstWhere(
          (o) => o.id == orderId,
          orElse: () => throw Exception('Order not found'),
        );

        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          appBar: AppBar(
            title: const Text('Order Details'),
            backgroundColor: AppTheme.backgroundLight,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Order ${order.id}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  'Placed on ${DateFormat.yMMMd().format(order.date)}',
                ),
                trailing: Chip(
                  label: Text(order.status),
                  backgroundColor: _getStatusColor(
                    order.status,
                  ).withValues(alpha: 0.1),
                  labelStyle: TextStyle(color: _getStatusColor(order.status)),
                ),
              ),
              const Divider(),
              const Text(
                'Items',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...order.items.map((item) => _item(item)),
              const SizedBox(height: 12),
              const Text(
                'Shipping Address',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              const Text(
                '123 Riverside Drive\nNairobi, Kenya',
              ), // Mock address for now
              const SizedBox(height: 12),
              const Text(
                'Payment',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              const Text('Paid via M-Pesa'), // Mock payment method
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.pushNamed('/delivery-tracking'),
                child: const Text('Track Order'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => context.pushNamed('/product-reviews'),
                child: const Text('Write a Review'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _item(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: item.product.imageUrl.startsWith('assets')
                  ? AssetImage(item.product.imageUrl) as ImageProvider
                  : NetworkImage(item.product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(item.product.name),
        subtitle: Text('Qty ${item.quantity}'),
        trailing: Text(
          '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return AppTheme.primary;
      case 'Shipped':
        return Colors.blue;
      default:
        return AppTheme.ochreEarth;
    }
  }
}
