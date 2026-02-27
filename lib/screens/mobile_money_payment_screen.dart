import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';

class MobileMoneyPaymentScreen extends ConsumerStatefulWidget {
  final double total;
  const MobileMoneyPaymentScreen({super.key, this.total = 0.0});

  @override
  ConsumerState<MobileMoneyPaymentScreen> createState() =>
      _MobileMoneyPaymentScreenState();
}

class _MobileMoneyPaymentScreenState
    extends ConsumerState<MobileMoneyPaymentScreen> {
  bool _isWaiting = false;
  String _state = 'idle';
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _startPayment() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    setState(() {
      _isWaiting = true;
      _state = 'waiting';
    });

    // Simulate STK push
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _isWaiting = false;
        _state = 'success';
      });
    });
  }

  void _finalizeOrder() {
    final cartItems = ref.read(cartProvider);
    final total = widget.total > 0
        ? widget.total
        : ref.read(cartProvider.notifier).total;

    // Create order
    final order = ref
        .read(ordersProvider.notifier)
        .addPromisedOrder(
          cartItems,
          total,
          paymentMethod: 'M-Pesa (${_phoneController.text})',
          shippingAddress:
              '123 Riverside Drive, Nairobi', // In real app, pass this
        );

    // Clear cart
    ref.read(cartProvider.notifier).clearCart();

    // Navigate to confirmation with order
    context.go('/order-confirmation', extra: order);
  }

  @override
  Widget build(BuildContext context) {
    // If total wasn't passed, try to calculate it (fallback)
    final displayTotal = widget.total > 0
        ? widget.total
        : ref.watch(cartProvider.notifier).total;

    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Money Payment')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.sageMist.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.sageMist),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Amount to Pay'),
                  Text(
                    'KES ${displayTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepForest,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Merchant: Atelier Maison',
              style: TextStyle(color: AppTheme.ochreEarth),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixText: '+254 ',
                border: OutlineInputBorder(),
                helperText: 'Enter M-Pesa phone number',
              ),
              keyboardType: TextInputType.phone,
              enabled: _state == 'idle',
            ),
            const SizedBox(height: 24),
            if (_state == 'waiting')
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                title: Text('Awaiting confirmation'),
                subtitle: Text('Check your phone for the M-Pesa prompt...'),
              ),
            if (_state == 'success')
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Successful',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text('Ref: QWE123XYZ'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isWaiting
                    ? null
                    : () {
                        if (_state == 'success') {
                          _finalizeOrder();
                        } else {
                          _startPayment();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: _state == 'success'
                      ? Colors.green
                      : AppTheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  _state == 'success' ? 'Complete Order' : 'Pay Now',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
