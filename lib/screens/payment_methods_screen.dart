import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Mobile Money',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(Icons.phone_android, color: AppTheme.primary),
            title: const Text('M-Pesa'),
            subtitle: const Text('Pay via STK push'),
            onTap: () => context.push('/mobile-money-payment'),
          ),
          const SizedBox(height: 20),
          const Text('Cards', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(Icons.credit_card),
            title: const Text('Add New Card'),
            subtitle: const Text('Visa, Mastercard, Amex'),
            onTap: () => context.push('/add-new-card'),
          ),
        ],
      ),
    );
  }
}
