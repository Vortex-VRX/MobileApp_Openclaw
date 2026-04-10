import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/mock_data.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import 'product_detail_sheet.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.compact = false,
    this.showComparisonSummary = true,
  });

  final ProductModel product;
  final bool compact;
  final bool showComparisonSummary;

  StoreModel _storeById(String id) => stores.firstWhere((store) => store.id == id);

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final cheapest = product.cheapestOption;
    final bestUnit = product.bestUnitOption;
    final cheapestStore = _storeById(cheapest.storeId);
    final bestUnitStore = _storeById(bestUnit.storeId);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ProductDetailSheet(product: product),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: compact ? 24 : 26, child: Text(product.imageEmoji, style: const TextStyle(fontSize: 22))),
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
                IconButton(
                  onPressed: () => appState.toggleFavorite(product.id),
                  icon: Icon(appState.isFavorite(product.id) ? Icons.favorite : Icons.favorite_border),
                ),
              ],
            ),
            if (!compact) ...[
              const SizedBox(height: 12),
              Text(product.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black87)),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _metricCard('Cheapest', cheapestStore.name, '\$${cheapest.price.toStringAsFixed(2)}')),
                const SizedBox(width: 12),
                Expanded(child: _metricCard('Best unit', bestUnitStore.name, '\$${bestUnit.unitPrice.toStringAsFixed(2)}/${bestUnit.unitLabel}')),
              ],
            ),
            if (showComparisonSummary) ...[
              const SizedBox(height: 16),
              ...product.priceOptions.take(compact ? 2 : product.priceOptions.length).map((option) {
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
