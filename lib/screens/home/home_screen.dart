import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../data/mock_data.dart';
import '../../models/product_model.dart';
import '../../models/store_model.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  StoreModel _storeById(String id) => stores.firstWhere((store) => store.id == id);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final featured = products.first;
    final bestCartStore = _bestCartStore();
    final appState = AppStateScope.of(context);
    final favoriteProducts = products.where((product) => appState.isFavorite(product.id)).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shop smarter', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('Compare prices across nearby grocery stores in seconds.', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.black54)),
                  ],
                ),
              ),
              const CircleAvatar(radius: 24, child: Icon(Icons.savings_outlined)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('This week\'s smartest cart', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text(bestCartStore.name, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Estimated total for sample cart: \$${_cartTotal(bestCartStore.id).toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    _chip('${bestCartStore.distanceMiles.toStringAsFixed(1)} mi away'),
                    _chip(bestCartStore.hasPickup ? 'Pickup' : 'In-store only'),
                    _chip(bestCartStore.membershipRequired ? 'Membership pricing' : 'No membership'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Browse categories', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 116,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  width: 140,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.icon, style: const TextStyle(fontSize: 28)),
                      const Spacer(),
                      Text(category.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('${category.itemCount} items', style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text('Featured comparison', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _featuredCard(featured),
          const SizedBox(height: 24),
          Text('Your favorites', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (favoriteProducts.isEmpty)
            const Text('Save items to favorites to watch price drops and compare later.')
          else
            ...favoriteProducts.map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProductCard(product: product, compact: true, showComparisonSummary: false),
              ),
            ),
          const SizedBox(height: 24),
          Text('Best-value items', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...products.take(4).map((product) {
            final cheapest = product.cheapestOption;
            final store = _storeById(cheapest.storeId);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                leading: CircleAvatar(radius: 24, child: Text(product.imageEmoji, style: const TextStyle(fontSize: 22))),
                title: Text(product.name),
                subtitle: Text('${product.brand} • ${store.name}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${cheapest.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('\$${cheapest.unitPrice.toStringAsFixed(2)}/${cheapest.unitLabel}', style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(100)),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _featuredCard(ProductModel product) {
    return ProductCard(product: product, showComparisonSummary: true);
  }

  StoreModel _bestCartStore() {
    final totals = {for (final store in stores) store.id: _cartTotal(store.id)};
    final bestStoreId = totals.entries.reduce((a, b) => a.value <= b.value ? a : b).key;
    return _storeById(bestStoreId);
  }

  double _cartTotal(String storeId) {
    var total = 0.0;
    for (final product in products.take(4)) {
      final option = product.priceOptions.firstWhere((item) => item.storeId == storeId);
      total += option.membershipPrice ?? option.price;
    }
    return total;
  }
}
