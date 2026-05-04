import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../data/mock_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = AppStateScope.of(context);
    final favoritesCount = products.where((product) => appState.isFavorite(product.id)).length;
    final cartCount = products.where((product) => appState.inCart(product.id)).length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        children: [
          Text('Your savings', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 6),
          const Text('Cart tracking, favorites, and price alerts.', style: TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0AAD0A),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Icon(Icons.person_outline, color: Color(0xFF0AAD0A))),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Budget shopper mode', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                      SizedBox(height: 4),
                      Text('Wakefield, MA 01880', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _StatTile(icon: Icons.shopping_cart_outlined, label: 'Cart', value: '$cartCount')),
              const SizedBox(width: 10),
              Expanded(child: _StatTile(icon: Icons.favorite_outline, label: 'Favorites', value: '$favoritesCount')),
              const SizedBox(width: 10),
              const Expanded(child: _StatTile(icon: Icons.notifications_outlined, label: 'Alerts', value: '2')),
            ],
          ),
          const SizedBox(height: 18),
          _MenuGroup(
            children: const [
              _MenuRow(icon: Icons.notifications_active_outlined, title: 'Price drop alerts', subtitle: 'Milk, eggs, chicken breast'),
              _MenuRow(icon: Icons.storefront_outlined, title: 'Preferred stores', subtitle: 'BJ\'s, Market Basket, Costco'),
              _MenuRow(icon: Icons.workspace_premium_outlined, title: 'Premium features', subtitle: 'Smart alerts and personalized savings'),
              _MenuRow(icon: Icons.receipt_long_outlined, title: 'Future tools', subtitle: 'Receipt scanning and route optimization'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0AAD0A)),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
          Text(label, style: const TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Column(children: children),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0AAD0A)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
