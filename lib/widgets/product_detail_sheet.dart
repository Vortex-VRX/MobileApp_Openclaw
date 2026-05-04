import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/mock_data.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';

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
    final cheapestPrice = cheapest.membershipPrice ?? cheapest.price;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF6F7F9),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(99)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  CircleAvatar(radius: 32, child: Text(product.imageEmoji, style: const TextStyle(fontSize: 28))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('${product.brand} • ${product.packageInfo}', style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => appState.toggleFavorite(product.id),
                    icon: Icon(appState.isFavorite(product.id) ? Icons.favorite : Icons.favorite_border),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(product.description, style: const TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: product.tags
                    .map((tag) => Chip(label: Text(tag), backgroundColor: Colors.white))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _statCard('Cheapest', '\$${cheapestPrice.toStringAsFixed(2)}')),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard('Best unit', '\$${product.bestUnitOption.unitPrice.toStringAsFixed(2)}/${product.bestUnitOption.unitLabel}')),
                  const SizedBox(width: 12),
                  Expanded(child: _statCard('Health', '${product.healthyScore}/100')),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Store comparison', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...product.priceOptions.map((option) {
                final store = _storeById(option.storeId);
                final displayPrice = option.membershipPrice ?? option.price;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                    child: Column(
                      children: [
                        Row(
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
                            Text(option.availability ? 'In stock' : 'Unavailable', style: TextStyle(color: option.availability ? Colors.green : Colors.red)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('\$${displayPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text('\$${option.unitPrice.toStringAsFixed(2)}/${option.unitLabel}', style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                        if (option.discountLabel != null || option.membershipPrice != null) ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              option.discountLabel ?? 'Member price available',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => appState.toggleCart(product.id),
                icon: Icon(appState.inCart(product.id) ? Icons.remove_shopping_cart : Icons.add_shopping_cart),
                label: Text(appState.inCart(product.id) ? 'Remove from cart' : 'Add to cart'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
