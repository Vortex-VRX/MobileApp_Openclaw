import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/mock_data.dart';
import '../models/price_option.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import '../screens/products/product_detail_page.dart';
import 'product_image.dart';

class GroceryProductTile extends StatelessWidget {
  const GroceryProductTile({
    super.key,
    required this.product,
    this.store,
    this.width = 176,
  });

  final ProductModel product;
  final StoreModel? store;
  final double width;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final option = _priceOption();
    final displayPrice = option.membershipPrice ?? option.price;
    final originalPrice = option.membershipPrice == null ? null : option.price;
    final inCart = appState.inCart(product.id);

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
          ),
          child: Container(
            width: width,
            height: 284,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(width: 0.4, color: const Color(0xFFE4E7EC)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ProductImage(product: product, width: double.infinity, height: 118, borderRadius: 8, fit: BoxFit.contain),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(54, 32),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => appState.addToCart(product.id),
                          child: Text(inCart ? 'Added' : 'Add'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 4),
                Text(product.packageInfo, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF667085))),
                const Spacer(),
                Text(_storeName(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF667085), fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${displayPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 21)),
                    if (originalPrice != null) ...[
                      const SizedBox(width: 6),
                      Text('\$${originalPrice.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF98A2B3), decoration: TextDecoration.lineThrough)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PriceOption _priceOption() {
    if (store == null) {
      return product.cheapestOption;
    }
    return product.priceOptions.firstWhere((option) => option.storeId == store!.id, orElse: () => product.cheapestOption);
  }

  String _storeName() {
    if (store != null) {
      return store!.name;
    }
    final option = product.cheapestOption;
    return stores.firstWhere((item) => item.id == option.storeId, orElse: () => stores.first).name;
  }
}
