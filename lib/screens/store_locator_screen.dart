import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StoreLocatorScreen extends StatelessWidget {
  const StoreLocatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Locator')),
      body: Column(
        children: [
          Container(
            height: 220,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.sageMist.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(child: Icon(Icons.map, size: 72, color: AppTheme.deepForest)),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _StoreTile(name: 'Atelier Nairobi Flagship', address: 'Westlands, Nairobi', distance: '2.4 km'),
                _StoreTile(name: 'Atelier Karen', address: 'Karen, Nairobi', distance: '8.1 km'),
                _StoreTile(name: 'Atelier Mombasa', address: 'Nyali, Mombasa', distance: '440 km'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreTile extends StatelessWidget {
  final String name;
  final String address;
  final String distance;
  const _StoreTile({required this.name, required this.address, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_on, color: AppTheme.deepForest),
        title: Text(name),
        subtitle: Text('$address • $distance'),
        trailing: TextButton(onPressed: () {}, child: const Text('Directions')),
      ),
    );
  }
}
