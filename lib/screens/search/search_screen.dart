import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../data/mock_data.dart';
import '../../widgets/product_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = AppStateScope.of(context);

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
                    const Text('Find food items, add them, then compare stores.', style: TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              IconButton.filled(
                tooltip: 'Compare cart',
                onPressed: () => appState.selectTab(2),
                icon: Badge.count(count: appState.cartProductIds.length, isLabelVisible: appState.cartProductIds.isNotEmpty, child: const Icon(Icons.shopping_cart_outlined)),
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
              children: [
                const _FilterChip(label: 'Lowest price', selected: true),
                ...stores.map((store) => _FilterChip(label: store.name)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: categories.map((category) => _FilterChip(label: '${category.icon} ${category.title}')).toList()),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: Text('${products.length} groceries', style: theme.textTheme.titleLarge)),
              TextButton.icon(onPressed: () => appState.selectTab(2), icon: const Icon(Icons.compare_arrows), label: const Text('Compare')),
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
