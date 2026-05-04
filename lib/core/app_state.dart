import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  final Set<String> _favoriteProductIds = {'milk', 'banana'};
  final Set<String> _cartProductIds = {'milk', 'eggs', 'chicken', 'banana'};
  int _currentTabIndex = 0;

  Set<String> get favoriteProductIds => _favoriteProductIds;
  Set<String> get cartProductIds => _cartProductIds;
  int get currentTabIndex => _currentTabIndex;

  bool isFavorite(String productId) => _favoriteProductIds.contains(productId);
  bool inCart(String productId) => _cartProductIds.contains(productId);

  void selectTab(int index) {
    if (_currentTabIndex == index) {
      return;
    }
    _currentTabIndex = index;
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }

  void addToCart(String productId) {
    if (_cartProductIds.add(productId)) {
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    if (_cartProductIds.remove(productId)) {
      notifyListeners();
    }
  }

  void toggleCart(String productId) {
    if (_cartProductIds.contains(productId)) {
      _cartProductIds.remove(productId);
    } else {
      _cartProductIds.add(productId);
    }
    notifyListeners();
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in widget tree');
    return scope!.notifier!;
  }
}
