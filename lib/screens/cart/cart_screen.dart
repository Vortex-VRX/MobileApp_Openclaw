import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../data/mock_data.dart';
import '../../models/price_option.dart';
import '../../models/product_model.dart';
import '../../models/store_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  StoreModel _storeById(String id) => stores.firstWhere((store) => store.id == id);

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final cartItems = products.where((product) => appState.inCart(product.id)).toList();
    final totals = {
      for (final store in stores) store: _cartTotal(store.id, cartItems),
    }.entries.toList()
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
          if (cartItems.isEmpty)
            _emptyCart(context)
          else ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selected cart total', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
            ...cartItems.map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _CartProductComparisonCard(
                  product: product,
                  storeById: _storeById,
                  onRemove: () => appState.toggleCart(product.id),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _emptyCart(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shopping_cart_outlined, color: Theme.of(context).colorScheme.primary, size: 32),
          const SizedBox(height: 12),
          Text('Your cart is empty', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Add products from Search or product details to compare prices across stores here.', style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  double _cartTotal(String storeId, List<ProductModel> cartItems) {
    var total = 0.0;
    for (final product in cartItems) {
      final option = product.priceOptions.firstWhere((item) => item.storeId == storeId);
      total += option.membershipPrice ?? option.price;
    }
    return total;
  }
}

class _CartProductComparisonCard extends StatelessWidget {
  const _CartProductComparisonCard({
    required this.product,
    required this.storeById,
    required this.onRemove,
  });

  final ProductModel product;
  final StoreModel Function(String id) storeById;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cheapest = product.cheapestOption;
    final cheapestStore = storeById(cheapest.storeId);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 24, child: Text(product.imageEmoji, style: const TextStyle(fontSize: 22))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(product.brand, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remove from cart',
                onPressed: onRemove,
                icon: const Icon(Icons.remove_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(18)),
            child: Row(
              children: [
                const Icon(Icons.savings_outlined, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('Best price at ${cheapestStore.name}')),
                Text('\$${_displayPrice(cheapest).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...product.priceOptions.map((option) {
            final store = storeById(option.storeId);
            final displayPrice = _displayPrice(option);
            final isCheapest = option.storeId == cheapest.storeId;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7F9),
                  borderRadius: BorderRadius.circular(16),
                  border: isCheapest ? Border.all(color: const Color(0xFF2E7D32)) : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(store.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(option.availability ? 'In stock' : 'Unavailable', style: TextStyle(color: option.availability ? Colors.green : Colors.red)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${displayPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('\$${option.unitPrice.toStringAsFixed(2)}/${option.unitLabel}', style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  double _displayPrice(PriceOption option) => option.membershipPrice ?? option.price;
}
