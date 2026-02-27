import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundLight,
        title: const Text('Saved Addresses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const _AddressCard(
              title: 'Home',
              address: '123 Riverside Drive\nNairobi, Kenya',
              isDefault: true,
            ),
            const SizedBox(height: 16),
            const _AddressCard(
              title: 'Office',
              address: 'Westlands Business Centre\nNairobi, Kenya',
              isDefault: false,
            ),
            const SizedBox(height: 32),
            // Add new button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.sageMist, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppTheme.deepForest),
                  SizedBox(width: 8),
                  Text('Add New Address', style: TextStyle(color: AppTheme.deepForest, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final bool isDefault;

  const _AddressCard({required this.title, required this.address, required this.isDefault});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDefault ? Border.all(color: AppTheme.primary, width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (isDefault) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(4)),
                      child: const Text('Default', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  Icon(Icons.edit, size: 18, color: Colors.grey[400]),
                  const SizedBox(width: 12),
                  Icon(Icons.delete_outline, size: 18, color: Colors.grey[400]),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(address, style: const TextStyle(color: AppTheme.ochreEarth, height: 1.5)),
        ],
      ),
    );
  }
}
