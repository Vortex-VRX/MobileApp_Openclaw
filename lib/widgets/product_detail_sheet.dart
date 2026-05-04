import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/mock_data.dart';
import '../models/price_option.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import 'product_image.dart';

class ProductDetailSheet extends StatelessWidget {
  const ProductDetailSheet({super.key, required this.product});

  final ProductModel product;

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
    final cheapestPrice = _displayPrice(cheapest);
    final sortedOptions = [...product.priceOptions]
      ..sort((a, b) => _displayPrice(a).compareTo(_displayPrice(b)));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.92,
      minChildSize: 0.75,
      maxChildSize: 0.96,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF7F8F6),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(99)),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE4E7EC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ProductImage(product: product, width: double.infinity, height: 210, borderRadius: 22, fit: BoxFit.contain),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                            child: IconButton(
                              tooltip: 'Favorite',
                              onPressed: () => appState.toggleFavorite(product.id),
                              icon: Icon(appState.isFavorite(product.id) ? Icons.favorite : Icons.favorite_border),
                              color: appState.isFavorite(product.id) ? const Color(0xFF0AAD0A) : const Color(0xFF667085),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, height: 1.05)),
                          const SizedBox(height: 6),
                          Text('${product.brand} - ${product.packageInfo}', style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(child: _summaryTile('Best price', '$cheapestStoreName', '\$${cheapestPrice.toStringAsFixed(2)}', true)),
                              const SizedBox(width: 10),
                              Expanded(child: _summaryTile('Unit price', bestUnit.unitLabel, '\$${bestUnit.unitPrice.toStringAsFixed(2)}', false)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE4E7EC))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Compare by store', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    ...sortedOptions.map((option) => _StorePriceRow(option: option, store: _storeById(option.storeId), isBest: option.storeId == cheapest.storeId)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(product.description, style: const TextStyle(fontSize: 15, color: Color(0xFF475467), height: 1.35)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: product.tags.map((tag) => Chip(label: Text(tag), backgroundColor: Colors.white)).toList(),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => _handleCartAction(context, appState),
                icon: Icon(appState.inCart(product.id) ? Icons.compare_arrows : Icons.add_shopping_cart),
                label: Text(appState.inCart(product.id) ? 'View compare' : 'Add and compare'),
              ),
            ],
          ),
        );
      },
    );
  }

  String get cheapestStoreName => _storeById(product.cheapestOption.storeId).name;

  void _handleCartAction(BuildContext context, AppState appState) {
    if (appState.inCart(product.id)) {
      Navigator.of(context).pop();
      appState.selectTab(2);
      return;
    }

    appState.addToCart(product.id);
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Added to compare cart'),
          content: Text('${product.name} is ready to compare across stores.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Keep shopping'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
                appState.selectTab(2);
              },
              child: const Text('Compare prices'),
            ),
          ],
        );
      },
    );
  }

  Widget _summaryTile(String label, String detail, String value, bool highlighted) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFE9F8E9) : const Color(0xFFF7F8F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF667085), fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
          const SizedBox(height: 3),
          Text(detail, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  double _displayPrice(PriceOption option) => option.membershipPrice ?? option.price;
}

class _StorePriceRow extends StatelessWidget {
  const _StorePriceRow({required this.option, required this.store, required this.isBest});

  final PriceOption option;
  final StoreModel store;
  final bool isBest;

  @override
  Widget build(BuildContext context) {
    final displayPrice = option.membershipPrice ?? option.price;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isBest ? const Color(0xFFE9F8E9) : const Color(0xFFF7F8F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isBest ? const Color(0xFF0AAD0A) : const Color(0xFFE4E7EC)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(store.colorHex),
              child: Text(store.name.characters.first, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(store.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                  Text(option.availability ? 'In stock' : 'Unavailable', style: TextStyle(color: option.availability ? const Color(0xFF0AAD0A) : Colors.red, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${displayPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                Text('\$${option.unitPrice.toStringAsFixed(2)}/${option.unitLabel}', style: const TextStyle(color: Color(0xFF667085))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
