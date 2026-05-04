import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../data/mock_data.dart';
import '../../models/product_model.dart';
import '../../models/store_model.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  StoreModel _storeById(String id) => stores.firstWhere(
        (store) => store.id == id,
        orElse: () => StoreModel(
          id: id,
          name: 'Unknown store',
          type: 'Unavailable',
          distanceMiles: 0,
          hasPickup: false,
          hasDelivery: false,
          membershipRequired: false,
          colorHex: 0xFF9E9E9E,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = AppStateScope.of(context);
    final sampleCartItems = products.take(4).toList();
    final bestCartStore = _bestCartStore(sampleCartItems);
    final favoriteProducts = products.where((product) => appState.isFavorite(product.id)).toList();

    if (products.isEmpty) {
      return const SafeArea(
        child: Center(child: Text('No grocery products loaded yet.')),
      );
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Delivery to', style: TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Wakefield, MA 01880', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1F2933))),
                  ],
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE4E7EC))),
                child: IconButton(
                  tooltip: 'Compare cart',
                  onPressed: () => appState.selectTab(2),
                  icon: Badge.count(count: appState.cartProductIds.length, isLabelVisible: appState.cartProductIds.isNotEmpty, child: const Icon(Icons.shopping_cart_outlined)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            readOnly: true,
            onTap: () => appState.selectTab(1),
            decoration: const InputDecoration(
              hintText: 'Search groceries, brands, and stores',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 18),
          _SavingsBanner(store: bestCartStore, total: _cartTotal(bestCartStore.id, sampleCartItems), items: sampleCartItems.length),
          const SizedBox(height: 22),
          _SectionHeader(title: 'Shop food categories', action: 'See all', onTap: () => appState.selectTab(1)),
          const SizedBox(height: 12),
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  width: 118,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE4E7EC))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.icon, style: const TextStyle(fontSize: 28)),
                      const Spacer(),
                      Text(category.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                      Text('${category.itemCount} items', style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          _SectionHeader(title: 'Stores to compare', action: 'Stores', onTap: () => appState.selectTab(3)),
          const SizedBox(height: 12),
          SizedBox(
            height: 78,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: stores.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final store = stores[index];
                return Container(
                  width: 190,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE4E7EC))),
                  child: Row(
                    children: [
                      CircleAvatar(backgroundColor: Color(store.colorHex), child: Text(store.name.characters.first, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(store.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                            Text('${store.distanceMiles.toStringAsFixed(1)} mi - ${store.membershipRequired ? 'Member deals' : 'Open pricing'}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          _SectionHeader(title: 'Popular comparisons', action: 'Search', onTap: () => appState.selectTab(1)),
          const SizedBox(height: 12),
          ...products.take(3).map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProductCard(product: product, showComparisonSummary: true),
                ),
              ),
          const SizedBox(height: 12),
          _SectionHeader(title: 'Best-value items', action: 'Compare', onTap: () => appState.selectTab(2)),
          const SizedBox(height: 12),
          ...products.skip(3).take(5).map((product) {
            final cheapest = product.cheapestOption;
            final store = _storeById(cheapest.storeId);
            final displayPrice = cheapest.membershipPrice ?? cheapest.price;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => appState.addToCart(product.id),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE4E7EC))),
                  child: Row(
                    children: [
                      ProductImage(product: product, size: 58, borderRadius: 16),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                            const SizedBox(height: 3),
                            Text('${product.brand} - ${store.name}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF667085))),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$${displayPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                          Text('\$${cheapest.unitPrice.toStringAsFixed(2)}/${cheapest.unitLabel}', style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (favoriteProducts.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Your favorites', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            ...favoriteProducts.map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProductCard(product: product, compact: true, showComparisonSummary: false),
              ),
            ),
          ],
        ],
      ),
    );
  }

  StoreModel _bestCartStore(List<ProductModel> cartItems) {
    if (stores.isEmpty) {
      return const StoreModel(id: 'none', name: 'No stores yet', type: 'Unavailable', distanceMiles: 0, hasPickup: false, hasDelivery: false, membershipRequired: false, colorHex: 0xFF9E9E9E);
    }

    final totals = {
      for (final store in stores)
        if (_hasPricesForAllItems(store.id, cartItems)) store.id: _cartTotal(store.id, cartItems),
    };

    if (totals.isEmpty) {
      return stores.first;
    }

    final bestStoreId = totals.entries.reduce((a, b) => a.value <= b.value ? a : b).key;
    return _storeById(bestStoreId);
  }

  bool _hasPricesForAllItems(String storeId, List<ProductModel> cartItems) {
    return cartItems.every((product) => product.priceOptions.any((item) => item.storeId == storeId));
  }

  double _cartTotal(String storeId, List<ProductModel> cartItems) {
    var total = 0.0;
    for (final product in cartItems) {
      final options = product.priceOptions.where((item) => item.storeId == storeId);
      if (options.isEmpty) {
        continue;
      }
      final option = options.first;
      total += option.membershipPrice ?? option.price;
    }
    return total;
  }
}

class _SavingsBanner extends StatelessWidget {
  const _SavingsBanner({required this.store, required this.total, required this.items});

  final StoreModel store;
  final double total;
  final int items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0AAD0A),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Smartest cart today', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(store.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, height: 1.05)),
                const SizedBox(height: 8),
                Text('$items items from \$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.savings_outlined, color: Colors.white, size: 42),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action, required this.onTap});

  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }
}
