import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _price = const RangeValues(500, 5000);
  final Set<String> _materials = {'Wood'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filters')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Price Range',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          RangeSlider(
            values: _price,
            min: 0,
            max: 10000,
            divisions: 20,
            labels: RangeLabels(
              '\$${_price.start.round()}',
              '\$${_price.end.round()}',
            ),
            onChanged: (v) => setState(() => _price = v),
          ),
          const SizedBox(height: 12),
          const Text('Material', style: TextStyle(fontWeight: FontWeight.w600)),
          Wrap(
            spacing: 8,
            children: ['Wood', 'Leather', 'Metal', 'Fabric']
                .map(
                  (m) => FilterChip(
                    label: Text(m),
                    selected: _materials.contains(m),
                    selectedColor: AppTheme.deepForest,
                    labelStyle: TextStyle(
                      color: _materials.contains(m) ? Colors.white : null,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _materials.add(m);
                        } else {
                          _materials.remove(m);
                        }
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _price = const RangeValues(500, 5000);
                    _materials
                      ..clear()
                      ..add('Wood');
                  });
                },
                child: const Text('Reset'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.go('/search-results'),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
