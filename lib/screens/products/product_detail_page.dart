import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../data/mock_data.dart';
import '../../models/price_option.dart';
import '../../models/product_model.dart';
import '../../models/store_model.dart';
import '../../widgets/product_image.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final cheapest = product.cheapestOption;
    final cheapestStore = _storeById(cheapest.storeId);
    final cheapestPrice = _price(cheapest);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            tooltip: 'Favorite',
            onPressed: () => appState.toggleFavorite(product.id),
            icon: Icon(appState.isFavorite(product.id) ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Row(
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(minimumSize: const Size(56, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () => appState.addToCart(product.id),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    appState.addToCart(product.id);
                    appState.selectTab(2);
                    Navigator.of(context).pop();
                  },
                  child: Text(appState.inCart(product.id) ? 'View Compare' : 'Add to Compare'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFF7F8F6),
              padding: const EdgeInsets.all(18),
              child: ProductImage(product: product, width: double.infinity, height: 280, borderRadius: 8, fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 8),
                  Text('Weight: ${product.packageInfo}', style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${cheapestPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.w900)),
                      const SizedBox(width: 8),
                      Text(cheapestStore.name, style: const TextStyle(color: Color(0xFF0AAD0A), fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text('Product Details', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 8),
                  Text(product.description, style: const TextStyle(height: 1.35)),
                  const SizedBox(height: 18),
                  Text('Compare Stores', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 10),
                  ...product.priceOptions.map((option) => _StoreCompareRow(option: option, store: _storeById(option.storeId), isBest: option.storeId == cheapest.storeId)),
                  const SizedBox(height: 10),
                  const Divider(thickness: 0.1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.star, color: Color(0xFFFFB020)),
                    title: const Text('Compare rating', style: TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text('${product.healthyScore}/100 product score'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  const Divider(thickness: 0.1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  StoreModel _storeById(String id) => stores.firstWhere(
        (store) => store.id == id,
        orElse: () => const StoreModel(id: 'unknown', name: 'Unknown store', type: 'Unavailable', distanceMiles: 0, hasPickup: false, hasDelivery: false, membershipRequired: false, colorHex: 0xFF9E9E9E),
      );

  double _price(PriceOption option) => option.membershipPrice ?? option.price;
}

class _StoreCompareRow extends StatelessWidget {
  const _StoreCompareRow({required this.option, required this.store, required this.isBest});

  final PriceOption option;
  final StoreModel store;
  final bool isBest;

  @override
  Widget build(BuildContext context) {
    final displayPrice = option.membershipPrice ?? option.price;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isBest ? const Color(0xFFE9F8E9) : const Color(0xFFF7F8F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isBest ? const Color(0xFF0AAD0A) : const Color(0xFFE4E7EC)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: Color(store.colorHex), child: Text(store.name.characters.first, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(store.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                Text(option.availability ? 'In stock' : 'Unavailable', style: TextStyle(color: option.availability ? const Color(0xFF0AAD0A) : Colors.red)),
              ],
            ),
          ),
          Text('\$${displayPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }
}
