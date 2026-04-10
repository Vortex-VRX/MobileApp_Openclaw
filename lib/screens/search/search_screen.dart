import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/product_model.dart';
import '../../models/store_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  StoreModel _storeById(String id) => stores.firstWhere((store) => store.id == id);

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
          ...products.map(_productCard),
        ],
      ),
    );
  }

  Widget _productCard(ProductModel product) {
    final cheapest = product.cheapestOption;
    final bestUnit = product.bestUnitOption;
    final cheapestStore = _storeById(cheapest.storeId);
    final bestUnitStore = _storeById(bestUnit.storeId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 26, child: Text(product.imageEmoji, style: const TextStyle(fontSize: 22))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('${product.brand} • ${product.category}', style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _metricCard('Cheapest', cheapestStore.name, '\$${cheapest.price.toStringAsFixed(2)}')),
                const SizedBox(width: 12),
                Expanded(child: _metricCard('Best unit', bestUnitStore.name, '\$${bestUnit.unitPrice.toStringAsFixed(2)}/${bestUnit.unitLabel}')),
              ],
            ),
            const SizedBox(height: 16),
            ...product.priceOptions.map((option) {
              final store = _storeById(option.storeId);
              final displayPrice = option.membershipPrice ?? option.price;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(store.name)),
                    Text(option.availability ? 'In stock' : 'Unavailable', style: TextStyle(color: option.availability ? Colors.green : Colors.red)),
                    const SizedBox(width: 12),
                    Text('\$${displayPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(String label, String store, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF6F7F9), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Text(store, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
