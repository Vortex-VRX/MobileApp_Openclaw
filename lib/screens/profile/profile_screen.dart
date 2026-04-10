import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../data/mock_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final favoritesCount = products.where((product) => appState.isFavorite(product.id)).length;
    final cartCount = products.where((product) => appState.inCart(product.id)).length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Profile & alerts', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Icon(Icons.person_outline)),
                  title: Text('Budget shopper mode'),
                  subtitle: Text('Price drop alerts, weekly deals, and savings insights enabled'),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.favorite_outline),
                  title: const Text('Favorites being watched'),
                  subtitle: Text('$favoritesCount products tracked for price movement'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.shopping_cart_outlined),
                  title: const Text('Active smart cart'),
                  subtitle: Text('$cartCount products currently used in total comparison'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.notifications_active_outlined),
                  title: Text('Price drop alerts'),
                  subtitle: Text('Milk, eggs, chicken breast'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.workspace_premium_outlined),
                  title: Text('Premium features'),
                  subtitle: Text('Ad-free mode, smart alerts, personalized recommendations'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.receipt_long_outlined),
                  title: Text('Future features'),
                  subtitle: Text('Receipt scanning, AI substitutions, route optimization'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
