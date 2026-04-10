import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/product_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Search & compare', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Search milk, bananas, eggs...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.tune),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              Chip(label: Text('Lowest price')),
              Chip(label: Text('Best unit value')),
              Chip(label: Text('In stock')),
              Chip(label: Text('Pickup')),
            ],
          ),
          const SizedBox(height: 20),
          ...products.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ProductCard(product: product),
            ),
          ),
        ],
      ),
    );
  }
}
