import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category_model.dart';
import '../models/price_option.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';

class CatalogData {
  const CatalogData({
    required this.stores,
    required this.categories,
    required this.products,
  });

  final List<StoreModel> stores;
  final List<CategoryModel> categories;
  final List<ProductModel> products;
}

class SupabaseCatalogRepository {
  SupabaseCatalogRepository(this._client);

  final SupabaseClient _client;

  Future<CatalogData> loadCatalog() async {
    final results = await Future.wait([
      _client.from('stores').select().eq('active', true).order('name'),
      _client.from('categories').select().eq('active', true).order('sort_order'),
      _client.from('products').select().eq('active', true).order('name'),
      _client.from('product_prices').select().order('product_id'),
    ]);

    final storeRows = _rows(results[0]);
    final categoryRows = _rows(results[1]);
    final productRows = _rows(results[2]);
    final priceRows = _rows(results[3]);
    final activeStoreIds = storeRows.map((row) => row['id'] as String).toSet();

    final categoriesById = {
      for (final row in categoryRows) row['id'] as String: row,
    };

    final pricesByProduct = <String, List<PriceOption>>{};
    for (final row in priceRows) {
      final storeId = row['store_id'] as String;
      if (!activeStoreIds.contains(storeId)) {
        continue;
      }
      final productId = row['product_id'] as String;
      pricesByProduct.putIfAbsent(productId, () => []).add(_priceFromRow(row));
    }

    final products = productRows
        .map((row) {
          final categoryId = row['category_id'] as String;
          final categoryTitle = categoriesById[categoryId]?['title'] as String? ?? categoryId;
          return _productFromRow(row, categoryTitle, pricesByProduct[row['id']] ?? const []);
        })
        .where((product) => product.priceOptions.isNotEmpty)
        .toList();

    final countsByCategory = <String, int>{};
    for (final row in productRows) {
      final productId = row['id'] as String;
      if ((pricesByProduct[productId] ?? const []).isEmpty) {
        continue;
      }
      final categoryId = row['category_id'] as String;
      countsByCategory[categoryId] = (countsByCategory[categoryId] ?? 0) + 1;
    }

    return CatalogData(
      stores: storeRows.map(_storeFromRow).toList(),
      categories: categoryRows.map((row) => _categoryFromRow(row, countsByCategory[row['id']] ?? 0)).toList(),
      products: products,
    );
  }

  List<Map<String, dynamic>> _rows(Object? response) {
    return (response as List).cast<Map<String, dynamic>>();
  }

  StoreModel _storeFromRow(Map<String, dynamic> row) {
    return StoreModel(
      id: row['id'] as String,
      name: row['name'] as String,
      type: row['type'] as String,
      distanceMiles: _double(row['distance_miles']),
      hasPickup: row['has_pickup'] as bool? ?? false,
      hasDelivery: row['has_delivery'] as bool? ?? false,
      membershipRequired: row['membership_required'] as bool? ?? false,
      colorHex: _color(row['color_hex'] as String? ?? '#2E7D32'),
    );
  }

  CategoryModel _categoryFromRow(Map<String, dynamic> row, int itemCount) {
    return CategoryModel(
      id: row['id'] as String,
      title: row['title'] as String,
      icon: row['icon'] as String,
      itemCount: itemCount,
    );
  }

  ProductModel _productFromRow(
    Map<String, dynamic> row,
    String categoryTitle,
    List<PriceOption> prices,
  ) {
    return ProductModel(
      id: row['id'] as String,
      name: row['name'] as String,
      brand: row['brand'] as String,
      category: categoryTitle,
      packageInfo: row['package_info'] as String,
      imageEmoji: row['image_emoji'] as String,
      imageUrl: row['image_url'] as String?,
      healthyScore: row['healthy_score'] as int? ?? 0,
      description: row['description'] as String,
      tags: List<String>.from(row['tags'] as List? ?? const []),
      priceOptions: prices,
    );
  }

  PriceOption _priceFromRow(Map<String, dynamic> row) {
    return PriceOption(
      storeId: row['store_id'] as String,
      price: _double(row['price']),
      unitPrice: _double(row['unit_price']),
      unitLabel: row['unit_label'] as String,
      availability: row['availability'] as bool? ?? false,
      discountLabel: row['discount_label'] as String?,
      membershipPrice: row['membership_price'] == null ? null : _double(row['membership_price']),
    );
  }

  double _double(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  int _color(String hex) {
    final normalized = hex.replaceFirst('#', '').toUpperCase();
    final rgb = int.tryParse(normalized, radix: 16) ?? 0x2E7D32;
    return 0xFF000000 | rgb;
  }
}
