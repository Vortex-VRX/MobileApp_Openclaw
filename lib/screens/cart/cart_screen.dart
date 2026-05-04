import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../data/mock_data.dart';
import '../../models/price_option.dart';
import '../../models/product_model.dart';
import '../../models/store_model.dart';
import '../../widgets/product_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  StoreModel _storeById(String id) => stores.firstWhere((store) => store.id == id, orElse: () => StoreModel(id: id, name: 'Unknown store', type: 'Unavailable', distanceMiles: 0, hasPickup: false, hasDelivery: false, membershipRequired: false, colorHex: 0xFF9E9E9E));

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final cartItems = products.where((product) => appState.inCart(product.id)).toList();
    final totals = {
      for (final store in stores)
        if (_hasPricesForAllItems(store.id, cartItems)) store: _cartTotal(store.id, cartItems),
    }.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final best = totals.isEmpty ? null : totals.first;
    final worst = totals.isEmpty ? null : totals.last;
    final savings = best == null || worst == null ? 0.0 : worst.value - best.value;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        children: [
          Text('Compare cart', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 6),
          const Text('See which store wins before you shop.', style: TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),
          if (cartItems.isEmpty)
            _emptyCart(context)
          else ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0AAD0A),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Best cart match', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(best?.key.name ?? 'Collecting prices', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28)),
                  const SizedBox(height: 8),
                  Text(
                    best == null || worst == null
                        ? 'Prices are still being collected for the selected stores.'
                        : 'Estimated total \$${best.value.toStringAsFixed(2)} • Save \$${savings.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ...totals.map((entry) {
              final store = entry.key;
              final isBest = best != null && store.id == best.key.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: isBest ? const Color(0xFF0AAD0A) : const Color(0xFFE4E7EC), width: isBest ? 1.5 : 1),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: Color(store.colorHex), child: Text(store.name.characters.first, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(store.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                            Text('${store.distanceMiles.toStringAsFixed(1)} mi • ${store.type}', style: const TextStyle(color: Color(0xFF667085))),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$${entry.value.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                          if (isBest) const Text('Best', style: TextStyle(color: Color(0xFF0AAD0A), fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 18),
            Text('Items selected', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...cartItems.map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _CartProductComparisonCard(
                  product: product,
                  storeById: _storeById,
                  onRemove: () => appState.removeFromCart(product.id),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE4E7EC))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.compare_arrows, color: Theme.of(context).colorScheme.primary, size: 34),
          const SizedBox(height: 12),
          Text('Nothing to compare yet', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('Add products from Search or product details to compare prices across stores here.', style: TextStyle(color: Color(0xFF667085))),
        ],
      ),
    );
  }

  bool _hasPricesForAllItems(String storeId, List<ProductModel> cartItems) {
    return cartItems.every((product) => product.priceOptions.any((item) => item.storeId == storeId));
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE4E7EC))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProductImage(product: product, size: 56, borderRadius: 16),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                    Text(product.brand, style: const TextStyle(color: Color(0xFF667085))),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Remove from compare cart',
                onPressed: onRemove,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFE9F8E9), borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                const Icon(Icons.savings_outlined, size: 20, color: Color(0xFF087D08)),
                const SizedBox(width: 8),
                Expanded(child: Text('Best price at ${cheapestStore.name}', style: const TextStyle(fontWeight: FontWeight.w800))),
                Text('\$${_displayPrice(cheapest).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900)),
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
                  color: const Color(0xFFF7F8F6),
                  borderRadius: BorderRadius.circular(14),
                  border: isCheapest ? Border.all(color: const Color(0xFF0AAD0A)) : null,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(store.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                          Text(option.availability ? 'In stock' : 'Unavailable', style: TextStyle(color: option.availability ? const Color(0xFF0AAD0A) : Colors.red)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${displayPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900)),
                        Text('\$${option.unitPrice.toStringAsFixed(2)}/${option.unitLabel}', style: const TextStyle(color: Color(0xFF667085))),
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
