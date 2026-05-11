import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../data/mock_data.dart';
import '../../models/category_model.dart';
import '../../models/store_model.dart';
import '../../screens/categories/category_products_screen.dart';
import '../../screens/stores/store_products_screen.dart';
import '../../widgets/grocery_product_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ElevatedButton(
                onPressed: () => appState.selectTab(4),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF2F6F3), shape: const CircleBorder(), padding: EdgeInsets.zero),
                child: const Icon(Icons.menu, color: Colors.black),
              ),
            ),
            title: const Text('OpenClaw', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0AAD0A))),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                child: ElevatedButton(
                  onPressed: () => appState.selectTab(1),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF2F6F3), shape: const CircleBorder(), padding: EdgeInsets.zero),
                  child: const Icon(Icons.search, color: Colors.black),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(child: _StoreHero(stores: stores)),
          SliverToBoxAdapter(child: _CategoryStrip(categories: categories)),
          ...stores.map((store) => SliverToBoxAdapter(child: _StoreProductShelf(store: store))),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _StoreHero extends StatelessWidget {
  const _StoreHero({required this.stores});

  final List<StoreModel> stores;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 18),
      child: Column(
        children: [
          _TitleAndAction(title: 'Stores', action: 'View all', onTap: () => AppStateScope.of(context).selectTab(3)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: stores.map((store) => _StoreBundleTile(store: store)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreBundleTile extends StatelessWidget {
  const _StoreBundleTile({required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final itemCount = products.where((product) => product.priceOptions.any((option) => option.storeId == store.id)).length;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: const Color(0xFFF2F6F3),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => StoreProductsScreen(store: store))),
          child: Container(
            width: 230,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 0.4, color: const Color(0xFFE4E7EC))),
            child: Row(
              children: [
                CircleAvatar(radius: 28, backgroundColor: Color(store.colorHex), child: Text(store.name.characters.first, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text('$itemCount grocery items', style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(store.membershipRequired ? 'Membership prices' : 'Open pricing', style: const TextStyle(color: Color(0xFF0AAD0A), fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({required this.categories});

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 18),
      child: Column(
        children: [
          _TitleAndAction(title: 'Target Food Categories', action: 'Search', onTap: () => AppStateScope.of(context).selectTab(1)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) => _CategoryTile(category: category)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CategoryProductsScreen(category: category))),
          child: Container(
            width: 132,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(width: 0.4, color: const Color(0xFFE4E7EC))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.icon, style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 16),
                Text(category.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('${category.itemCount} items', style: const TextStyle(color: Color(0xFF667085))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StoreProductShelf extends StatelessWidget {
  const _StoreProductShelf({required this.store});

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    final storeProducts = products.where((product) => product.priceOptions.any((option) => option.storeId == store.id)).toList();
    if (storeProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 18),
      child: Column(
        children: [
          _TitleAndAction(
            title: store.name,
            action: 'View all',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => StoreProductsScreen(store: store))),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: storeProducts.map((product) => GroceryProductTile(product: product, store: store)).toList()),
          ),
        ],
      ),
    );
  }
}

class _TitleAndAction extends StatelessWidget {
  const _TitleAndAction({required this.title, required this.action, required this.onTap});

  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black))),
          TextButton(onPressed: onTap, child: Text(action)),
        ],
      ),
    );
  }
}
