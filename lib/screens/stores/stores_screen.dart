import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import 'store_products_screen.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            title: Text('Stores'),
            centerTitle: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index.isOdd) {
                    return const SizedBox(height: 12);
                  }
                  final store = stores[index ~/ 2];
                  final itemCount = products.where((product) => product.priceOptions.any((option) => option.storeId == store.id)).length;

                  return Material(
                    color: const Color(0xFFF7F8F6),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => StoreProductsScreen(store: store))),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 0.4, color: const Color(0xFFE4E7EC))),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 30, backgroundColor: Color(store.colorHex), child: Text(store.name.characters.first, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24))),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(store.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('${store.type} - ${store.distanceMiles.toStringAsFixed(1)} mi', style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  Text('$itemCount products available', style: const TextStyle(color: Color(0xFF0AAD0A), fontWeight: FontWeight.w900)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: stores.isEmpty ? 0 : stores.length * 2 - 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
