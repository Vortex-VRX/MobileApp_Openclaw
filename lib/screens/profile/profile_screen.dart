import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_state.dart';
import '../../core/supabase_config.dart';
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
          Text('Account', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 6),
          const Text('Manage your profile, stores, alerts, and compare cart.', style: TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
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
                    children: [
                      Text(appState.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                      const SizedBox(height: 4),
                      Text(appState.userEmail, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _StatTile(icon: Icons.shopping_cart_outlined, label: 'Compare', value: '$cartCount', onTap: () => appState.selectTab(2))),
              const SizedBox(width: 10),
              Expanded(child: _StatTile(icon: Icons.favorite_outline, label: 'Favorites', value: '$favoritesCount', onTap: () => _showFavorites(context, appState))),
              const SizedBox(width: 10),
              Expanded(child: _StatTile(icon: Icons.storefront_outlined, label: 'Stores', value: '${stores.length}', onTap: () => appState.selectTab(3))),
            ],
          ),
          const SizedBox(height: 18),
          _MenuGroup(
            children: [
              _MenuRow(icon: Icons.notifications_active_outlined, title: 'Price drop alerts', subtitle: 'Set alerts for items in your compare cart', onTap: () => _showMessage(context, 'Price alerts', 'Alerts will watch your selected groceries and notify you when a better price appears.')),
              _MenuRow(icon: Icons.storefront_outlined, title: 'Preferred stores', subtitle: stores.map((store) => store.name).join(', '), onTap: () => appState.selectTab(3)),
              _MenuRow(icon: Icons.favorite_outline, title: 'Favorites', subtitle: '$favoritesCount saved groceries', onTap: () => _showFavorites(context, appState)),
              _MenuRow(icon: Icons.delete_outline, title: 'Clear compare cart', subtitle: 'Remove all selected groceries', onTap: appState.clearCart),
              _MenuRow(icon: Icons.logout, title: 'Sign out', subtitle: 'Return to login screen', onTap: () => _signOut(context, appState)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context, AppState appState) async {
    if (SupabaseConfig.isConfigured) {
      try {
        await Supabase.instance.client.auth.signOut();
      } catch (_) {}
    }
    appState.signOut();
  }

  void _showFavorites(BuildContext context, AppState appState) {
    final favorites = products.where((product) => appState.isFavorite(product.id)).toList();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Favorite groceries', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
          const SizedBox(height: 12),
          if (favorites.isEmpty)
            const Text('No favorites yet.')
          else
            ...favorites.map((product) => ListTile(title: Text(product.name), subtitle: Text(product.brand), trailing: const Icon(Icons.favorite, color: Color(0xFF0AAD0A)))),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String title, String body) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: Text(body),
        actions: [FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Done'))],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value, required this.onTap});

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
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
  const _MenuRow({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: const Color(0xFF0AAD0A)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
