import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/store_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  StoreModel _storeById(String id) => stores.firstWhere((store) => store.id == id);

  @override
  Widget build(BuildContext context) {
    final totals = {for (final store in stores) store: _cartTotal(store.id)}.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final best = totals.first;
    final worst = totals.last;
    final savings = worst.value - best.value;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Cart comparison', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sample cart total', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Save \$${savings.toStringAsFixed(2)} by shopping at ${best.key.name} instead of ${worst.key.name}.', style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 20),
                ...totals.map((entry) {
                  final store = entry.key;
                  final isBest = store.id == best.key.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isBest ? const Color(0xFFE8F5E9) : const Color(0xFFF6F7F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(store.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('${store.distanceMiles.toStringAsFixed(1)} mi • ${store.type}', style: const TextStyle(color: Colors.black54)),
                              ],
                            ),
                          ),
                          Text('\$${entry.value.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Items in cart', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...products.take(5).map((product) {
            final cheapest = product.cheapestOption;
            final bestUnit = product.bestUnitOption;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                leading: Text(product.imageEmoji, style: const TextStyle(fontSize: 24)),
                title: Text(product.name),
                subtitle: Text('Best price: ${_storeById(cheapest.storeId).name} • Best unit: ${_storeById(bestUnit.storeId).name}'),
                trailing: Text('\$${cheapest.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            );
          }),
        ],
      ),
    );
  }

  double _cartTotal(String storeId) {
    var total = 0.0;
    for (final product in products.take(5)) {
      final option = product.priceOptions.firstWhere((item) => item.storeId == storeId);
      total += option.membershipPrice ?? option.price;
    }
    return total;
  }
}
