import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/stores/stores_screen.dart';

class GroceryPriceCompareApp extends StatefulWidget {
  const GroceryPriceCompareApp({super.key});

  @override
  State<GroceryPriceCompareApp> createState() => _GroceryPriceCompareAppState();
}

class _GroceryPriceCompareAppState extends State<GroceryPriceCompareApp> {
  late final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    const StoresScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final currentIndex = appState.currentTabIndex;

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      floatingActionButton: FloatingActionButton(
        onPressed: () => appState.selectTab(2),
        backgroundColor: const Color(0xFF0AAD0A),
        child: Badge.count(
          count: appState.cartProductIds.length,
          isLabelVisible: appState.cartProductIds.isNotEmpty,
          child: const Icon(Icons.compare_arrows, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BottomItem(label: 'Home', icon: Icons.home_outlined, selectedIcon: Icons.home, isActive: currentIndex == 0, onTap: () => appState.selectTab(0)),
              _BottomItem(label: 'Menu', icon: Icons.search_outlined, selectedIcon: Icons.search, isActive: currentIndex == 1, onTap: () => appState.selectTab(1)),
              const SizedBox(width: 54),
              _BottomItem(label: 'Stores', icon: Icons.storefront_outlined, selectedIcon: Icons.storefront, isActive: currentIndex == 3, onTap: () => appState.selectTab(3)),
              _BottomItem(label: 'Profile', icon: Icons.person_outline, selectedIcon: Icons.person, isActive: currentIndex == 4, onTap: () => appState.selectTab(4)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({required this.label, required this.icon, required this.selectedIcon, required this.isActive, required this.onTap});

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF0AAD0A) : const Color(0xFF667085);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? selectedIcon : icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: isActive ? FontWeight.w900 : FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
