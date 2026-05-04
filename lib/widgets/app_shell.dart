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
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE4E7EC))),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: appState.selectTab,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Shop'),
            NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(icon: Icon(Icons.compare_arrows_outlined), selectedIcon: Icon(Icons.compare_arrows), label: 'Compare'),
            NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Stores'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'You'),
          ],
        ),
      ),
    );
  }
}
