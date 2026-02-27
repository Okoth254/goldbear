import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Reviews')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('4.8 out of 5', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
            subtitle: Text('128 reviews'),
            trailing: Icon(Icons.star, color: Colors.amber),
          ),
          const Divider(),
          _review('Amara K.', 5, 'Absolutely stunning quality and finish.'),
          _review('James O.', 4, 'Looks premium in person. Delivery was smooth.'),
          _review('Nia W.', 5, 'Worth every cent. Craftsmanship is top-tier.'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.deepForest,
        label: const Text('Write Review'),
        icon: const Icon(Icons.rate_review),
      ),
    );
  }

  static Widget _review(String name, int stars, String content) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (i) => Icon(i < stars ? Icons.star : Icons.star_border, size: 16, color: Colors.amber),
              ),
            ),
            const SizedBox(height: 6),
            Text(content),
          ],
        ),
      ),
    );
  }
}
