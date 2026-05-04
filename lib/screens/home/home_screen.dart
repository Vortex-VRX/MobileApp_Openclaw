import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../data/mock_data.dart';
import '../../models/category_model.dart';
import '../../models/price_option.dart';
import '../../models/product_model.dart';
import '../../models/store_model.dart';
import '../../widgets/product_detail_sheet.dart';
import '../../widgets/product_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

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
                    Text('Shopping in', style: TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('Wakefield, MA 01880', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1F2933))),
                  ],
                ),
              ),
              IconButton.filled(
                tooltip: 'Compare cart',
                onPressed: () => appState.selectTab(2),
                style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF1F2933)),
                icon: Badge.count(
                  count: appState.cartProductIds.length,
                  isLabelVisible: appState.cartProductIds.isNotEmpty,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            readOnly: true,
            onTap: () => appState.selectTab(1),
            decoration: const InputDecoration(
              hintText: 'Search groceries and compare prices',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 18),
          _SectionHeader(title: 'Stores near you', action: 'All stores', onTap: () => appState.selectTab(3)),
          const SizedBox(height: 12),
          SizedBox(
            height: 112,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: stores.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) => _StoreCard(store: stores[index]),
            ),
          ),
          const SizedBox(height: 22),
          _SectionHeader(title: 'Food categories', action: 'Search', onTap: () => appState.selectTab(1)),
          const SizedBox(height: 12),
          SizedBox(
            height: 104,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) => _CategoryPill(category: categories[index]),
            ),
          ),
          const SizedBox(height: 22),
          ...stores.map((store) {
            final storeProducts = _productsForStore(store.id);
            if (storeProducts.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StoreShelfHeader(store: store, itemCount: storeProducts.length),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 270,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: storeProducts.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final product = storeProducts[index];
                        final option = product.priceOptions.firstWhere((price) => price.storeId == store.id);
                        return _StoreProductTile(product: product, store: store, option: option);
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  List<ProductModel> _productsForStore(String storeId) {
    return products.where((product) => product.priceOptions.any((option) => option.storeId == storeId)).toList();
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE4E7EC))),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundColor: Color(store.colorHex), child: Text(store.name.characters.first, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(store.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 4),
                Text('${store.distanceMiles.toStringAsFixed(1)} mi - ${store.type}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(store.membershipRequired ? 'Membership prices' : 'Everyday prices', style: const TextStyle(color: Color(0xFF0AAD0A), fontWeight: FontWeight.w800, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 122,
      padding: const EdgeInsets.all(12),
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
  }
}

class _StoreShelfHeader extends StatelessWidget {
  const _StoreShelfHeader({required this.store, required this.itemCount});

  final StoreModel store;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 18, backgroundColor: Color(store.colorHex), child: Text(store.name.characters.first, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(store.name, style: Theme.of(context).textTheme.titleLarge),
              Text('$itemCount groceries available for comparison', style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

class _StoreProductTile extends StatelessWidget {
  const _StoreProductTile({required this.product, required this.store, required this.option});

  final ProductModel product;
  final StoreModel store;
  final PriceOption option;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final displayPrice = option.membershipPrice ?? option.price;
    final inCart = appState.inCart(product.id);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ProductDetailSheet(product: product),
      ),
      child: Container(
        width: 174,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE4E7EC))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ProductImage(product: product, width: double.infinity, height: 112, borderRadius: 16, fit: BoxFit.contain),
                Positioned(
                  top: 8,
                  right: 8,
                  child: SizedBox(
                    height: 32,
                    child: FilledButton(
                      style: FilledButton.styleFrom(minimumSize: const Size(58, 32), padding: const EdgeInsets.symmetric(horizontal: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
                      onPressed: () => appState.addToCart(product.id),
                      child: Text(inCart ? 'Added' : 'Add'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('\$${displayPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, height: 1.1)),
            const SizedBox(height: 3),
            Text(product.packageInfo, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
            const Spacer(),
            Text(option.availability ? store.name : 'Unavailable', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: option.availability ? const Color(0xFF0AAD0A) : Colors.red, fontWeight: FontWeight.w800, fontSize: 12)),
          ],
        ),
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
