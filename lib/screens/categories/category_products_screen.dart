import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../models/store_model.dart';
import '../../widgets/grocery_product_tile.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({
    super.key,
    required this.category,
    this.store,
  });

  final CategoryModel category;
  final StoreModel? store;

  @override
  Widget build(BuildContext context) {
    final categoryProducts = _productsForCategory();

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F6F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(category.icon, style: const TextStyle(fontSize: 40)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(category.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(_subtitle(categoryProducts.length), style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Search ${category.title}',
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (categoryProducts.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('No products loaded for ${category.title} yet.', textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w700)),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => GroceryProductTile(product: categoryProducts[index], store: store, width: 176),
                    childCount: categoryProducts.length,
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

  List<ProductModel> _productsForCategory() {
    return products.where((product) {
      final categoryMatches = product.categoryId == category.id;
      if (!categoryMatches) {
        return false;
      }
      final selectedStore = store;
      if (selectedStore == null) {
        return true;
      }
      return product.priceOptions.any((option) => option.storeId == selectedStore.id);
    }).toList();
  }

  String _subtitle(int count) {
    final storeName = store?.name;
    if (storeName == null) {
      return '$count products available';
    }
    return '$count products at $storeName';
  }
}
