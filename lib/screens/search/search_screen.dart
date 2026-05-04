import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/product_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Search groceries', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 6),
                    const Text('Wakefield, MA 01880', style: TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.tune),
                style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF1F2933)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Search milk, eggs, chicken...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                _FilterChip(label: 'Lowest price', selected: true),
                _FilterChip(label: 'In stock'),
                _FilterChip(label: 'BJ\'s'),
                _FilterChip(label: 'Market Basket'),
                _FilterChip(label: 'Costco'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: Text('${products.length} products', style: theme.textTheme.titleLarge)),
              const Text('Compare prices', style: TextStyle(color: Color(0xFF0AAD0A), fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 12),
          ...products.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ProductCard(product: product),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: selected ? const Color(0xFFE9F8E9) : Colors.white,
        side: BorderSide(color: selected ? const Color(0xFF0AAD0A) : const Color(0xFFE4E7EC)),
      ),
    );
  }
}
