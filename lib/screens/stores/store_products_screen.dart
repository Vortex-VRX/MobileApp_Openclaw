import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/product_model.dart';
import '../../models/store_model.dart';
import '../../widgets/grocery_product_tile.dart';

class StoreProductsScreen extends StatelessWidget {
  const StoreProductsScreen({super.key, required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final storeProducts = products.where((product) => product.priceOptions.any((option) => option.storeId == store.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(store.name),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: const Color(0xFFF7F8F6), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 28, backgroundColor: Color(store.colorHex), child: Text(store.name.characters.first, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22))),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(store.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                                const SizedBox(height: 4),
                                Text('${store.distanceMiles.toStringAsFixed(1)} mi - ${store.type}', style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(hintText: 'Search this store', prefixIcon: Icon(Icons.search)),
                    ),
                    const SizedBox(height: 16),
                    Text('All groceries', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => GroceryProductTile(product: storeProducts[index], store: store, width: 176),
                  childCount: storeProducts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.61,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
