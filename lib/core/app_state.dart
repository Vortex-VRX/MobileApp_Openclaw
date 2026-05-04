import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  final Set<String> _favoriteProductIds = {'milk', 'banana'};
  final Set<String> _cartProductIds = <String>{};
  int _currentTabIndex = 0;
  bool _isSignedIn = false;
  String _userEmail = '';
  String _userName = 'Guest shopper';

  Set<String> get favoriteProductIds => _favoriteProductIds;
  Set<String> get cartProductIds => _cartProductIds;
  int get currentTabIndex => _currentTabIndex;
  bool get isSignedIn => _isSignedIn;
  String get userEmail => _userEmail;
  String get userName => _userName;

  bool isFavorite(String productId) => _favoriteProductIds.contains(productId);
  bool inCart(String productId) => _cartProductIds.contains(productId);

  void signIn(String email) {
    _isSignedIn = true;
    _userEmail = email;
    _userName = email.isEmpty ? 'Guest shopper' : email.split('@').first;
    notifyListeners();
  }

  void signOut() {
    _isSignedIn = false;
    _currentTabIndex = 0;
    notifyListeners();
  }

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

  void clearCart() {
    if (_cartProductIds.isNotEmpty) {
      _cartProductIds.clear();
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
