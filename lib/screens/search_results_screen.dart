import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool _isGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => context.push('/filter'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Expanded(child: Text('24 items found')),
                IconButton(
                  onPressed: () => setState(() => _isGrid = !_isGrid),
                  icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isGrid
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: 8,
                    itemBuilder: (context, index) => _ResultCard(index: index),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 8,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ResultListTile(index: index),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final int index;
  const _ResultCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push('/product-detail/prod_${index + 1}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.sageMist.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.chair, color: AppTheme.deepForest),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Result ${index + 1}'),
                  Text(
                    '\$${(index + 1) * 400}',
                    style: const TextStyle(color: AppTheme.deepForest),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultListTile extends StatelessWidget {
  final int index;
  const _ResultListTile({required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push('/product-detail/prod_${index + 1}'),
      tileColor: Colors.white,
      leading: const CircleAvatar(
        backgroundColor: AppTheme.sageMist,
        child: Icon(Icons.chair, color: AppTheme.deepForest),
      ),
      title: Text('Result ${index + 1}'),
      subtitle: const Text('Premium collection'),
      trailing: Text('\$${(index + 1) * 400}'),
    );
  }
}
