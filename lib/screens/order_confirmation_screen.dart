import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/order.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final Order? order;

  // Constructor now accepts an optional Order object
  const OrderConfirmationScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    // Fallback if order is null (shouldn't happen in flow, but good for safety)
    final displayId = order?.id ?? '#ORD-????';
    final displayTotal = order?.total ?? 0.0;
    final displayDate = order?.date ?? DateTime.now();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppTheme.primary,
                  size: 48,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Order Confirmed!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Your bespoke piece is being curated.',
                style: TextStyle(color: AppTheme.ochreEarth),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Order details card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _OrderDetailRow(label: 'Order ID', value: displayId),
                    const Divider(height: 24),
                    _OrderDetailRow(
                      label: 'Date',
                      value: DateFormat.yMMMd().format(displayDate),
                    ),
                    const Divider(height: 24),
                    _OrderDetailRow(
                      label: 'Items',
                      value: '${order?.items.length ?? 0}',
                    ),
                    const Divider(height: 24),
                    _OrderDetailRow(
                      label: 'Total',
                      value: 'KES ${displayTotal.toStringAsFixed(2)}',
                      isBold: true,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/delivery-tracking'),
                  child: const Text('Track Order'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Continue Shopping'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _OrderDetailRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.ochreEarth)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? AppTheme.deepForest : null,
          ),
        ),
      ],
    );
  }
}
