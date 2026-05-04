import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/mock_data.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import '../screens/products/product_detail_page.dart';
import 'product_image.dart';

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
    final appState = AppStateScope.of(context);
    final cheapest = product.cheapestOption;
    final bestUnit = product.bestUnitOption;
    final cheapestStore = _storeById(cheapest.storeId);
    final bestUnitStore = _storeById(bestUnit.storeId);
    final cheapestPrice = cheapest.membershipPrice ?? cheapest.price;
    final inCart = appState.inCart(product.id);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailPage(product: product))),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE4E7EC), width: 0.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImage(product: product, size: compact ? 58 : 76, borderRadius: 8, fit: BoxFit.contain),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, height: 1.1, color: Colors.black)),
                      const SizedBox(height: 4),
                      Text('${product.brand} - ${product.packageInfo}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF667085))),
                      const SizedBox(height: 8),
                      Text('\$${cheapestPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black)),
                      Text('${cheapestStore.name} - \$${cheapest.unitPrice.toStringAsFixed(2)}/${cheapest.unitLabel}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: const Size(64, 34), padding: const EdgeInsets.symmetric(horizontal: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        onPressed: () => appState.addToCart(product.id),
                        child: Text(inCart ? 'Added' : 'Add'),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Favorite',
                      onPressed: () => appState.toggleFavorite(product.id),
                      icon: Icon(appState.isFavorite(product.id) ? Icons.favorite : Icons.favorite_border),
                      color: appState.isFavorite(product.id) ? const Color(0xFF0AAD0A) : const Color(0xFF667085),
                    ),
                  ],
                ),
              ],
            ),
            if (showComparisonSummary) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _metricCard('Cheapest', cheapestStore.name, '\$${cheapestPrice.toStringAsFixed(2)}', true)),
                  const SizedBox(width: 10),
                  Expanded(child: _metricCard('Best unit', bestUnitStore.name, '\$${bestUnit.unitPrice.toStringAsFixed(2)}/${bestUnit.unitLabel}', false)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _metricCard(String label, String store, String value, bool highlighted) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFE9F8E9) : const Color(0xFFF7F8F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF667085), fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(store, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black)),
        ],
      ),
    );
  }
}
