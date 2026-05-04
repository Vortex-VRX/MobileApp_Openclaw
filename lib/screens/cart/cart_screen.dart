import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../data/mock_data.dart';
import '../../models/product_model.dart';
import '../../models/store_model.dart';
import '../../widgets/product_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final cartItems = products.where((product) => appState.inCart(product.id)).toList();
    final totals = _storeTotals(cartItems);
    final best = totals.isEmpty ? null : totals.entries.reduce((a, b) => a.value <= b.value ? a : b);
    final worst = totals.isEmpty ? null : totals.entries.reduce((a, b) => a.value >= b.value ? a : b);
    final savings = best == null || worst == null ? 0.0 : worst.value - best.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Compare Cart'), centerTitle: true),
      body: SafeArea(
        child: cartItems.isEmpty
            ? _EmptyCart(onShop: () => appState.selectTab(0))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ...cartItems.map((product) => _SingleCartItemTile(product: product, onRemove: () => appState.removeFromCart(product.id))),
                    _CompareTotals(best: best, savings: savings, cartItems: cartItems),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: () => _showCompareResult(context, best, savings),
                          child: const Text('Compare Prices'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Map<StoreModel, double> _storeTotals(List<ProductModel> cartItems) {
    return {
      for (final store in stores)
        if (cartItems.isNotEmpty && cartItems.every((product) => product.priceOptions.any((option) => option.storeId == store.id))) store: _cartTotal(store.id, cartItems),
    };
  }

  double _cartTotal(String storeId, List<ProductModel> cartItems) {
    var total = 0.0;
    for (final product in cartItems) {
      final option = product.priceOptions.firstWhere((item) => item.storeId == storeId);
      total += option.membershipPrice ?? option.price;
    }
    return total;
  }

  void _showCompareResult(BuildContext context, MapEntry<StoreModel, double>? best, double savings) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text('Best store found'),
        content: Text(best == null ? 'Add more products with prices to compare stores.' : '${best.key.name} is best at \$${best.value.toStringAsFixed(2)}. Estimated savings: \$${savings.toStringAsFixed(2)}.'),
        actions: [ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Done'))],
      ),
    );
  }
}

class _SingleCartItemTile extends StatelessWidget {
  const _SingleCartItemTile({required this.product, required this.onRemove});

  final ProductModel product;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cheapest = product.cheapestOption;
    final displayPrice = cheapest.membershipPrice ?? cheapest.price;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ProductImage(product: product, size: 72, borderRadius: 8, fit: BoxFit.contain),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 4),
                Text(product.packageInfo, style: const TextStyle(color: Color(0xFF667085))),
                const SizedBox(height: 6),
                Text('\$${displayPrice.toStringAsFixed(2)} best price', style: const TextStyle(color: Color(0xFF0AAD0A), fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          IconButton(onPressed: onRemove, icon: const Icon(Icons.close)),
        ],
      ),
    );
  }
}

class _CompareTotals extends StatelessWidget {
  const _CompareTotals({required this.best, required this.savings, required this.cartItems});

  final MapEntry<StoreModel, double>? best;
  final double savings;
  final List<ProductModel> cartItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF7F8F6), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          _row('Items', '${cartItems.length}'),
          const Divider(thickness: 0.1),
          _row('Best store', best?.key.name ?? 'Collecting prices'),
          const Divider(thickness: 0.1),
          _row('Best total', best == null ? '--' : '\$${best!.value.toStringAsFixed(2)}'),
          const Divider(thickness: 0.1),
          _row('Estimated savings', '\$${savings.toStringAsFixed(2)}', highlight: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w700))),
          Text(value, style: TextStyle(color: highlight ? const Color(0xFF0AAD0A) : Colors.black, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.onShop});

  final VoidCallback onShop;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 56, color: Color(0xFF0AAD0A)),
            const SizedBox(height: 14),
            Text('Your compare cart is empty', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Add groceries from any store, then compare totals here.', textAlign: TextAlign.center),
            const SizedBox(height: 18),
            ElevatedButton(onPressed: onShop, child: const Text('Start Shopping')),
          ],
        ),
      ),
    );
  }
}
