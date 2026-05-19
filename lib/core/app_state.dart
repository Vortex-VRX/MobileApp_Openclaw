import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/mock_data.dart';
import '../data/supabase_catalog_repository.dart';
import 'supabase_config.dart';

class AppState extends ChangeNotifier {
  final Set<String> _favoriteProductIds = {'milk', 'banana'};
  final Set<String> _cartProductIds = <String>{};
  int _currentTabIndex = 0;
  bool _isSignedIn = false;
  bool _isRefreshingCatalog = false;
  String _userEmail = '';
  String _userName = 'Guest shopper';
  String _catalogStatus = 'Ready';
  DateTime? _lastCatalogRefresh;

  Set<String> get favoriteProductIds => _favoriteProductIds;
  Set<String> get cartProductIds => _cartProductIds;
  int get currentTabIndex => _currentTabIndex;
  bool get isSignedIn => _isSignedIn;
  bool get isRefreshingCatalog => _isRefreshingCatalog;
  String get userEmail => _userEmail;
  String get userName => _userName;
  String get catalogStatus => _catalogStatus;
  DateTime? get lastCatalogRefresh => _lastCatalogRefresh;

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

  Future<void> refreshCatalog() async {
    if (_isRefreshingCatalog) {
      return;
    }
    if (!SupabaseConfig.isConfigured) {
      _catalogStatus = 'Supabase is not configured';
      notifyListeners();
      return;
    }

    _isRefreshingCatalog = true;
    _catalogStatus = 'Refreshing grocery data...';
    notifyListeners();

    try {
      final repository = SupabaseCatalogRepository(Supabase.instance.client);
      final catalog = await repository.loadCatalog();
      replaceCatalogData(catalog);
      _lastCatalogRefresh = DateTime.now();
      _catalogStatus = 'Catalog updated';
    } catch (_) {
      _catalogStatus = 'Could not refresh catalog';
    } finally {
      _isRefreshingCatalog = false;
      notifyListeners();
    }
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
