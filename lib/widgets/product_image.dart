import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
    this.size = 56,
    this.borderRadius = 16,
  });

  final ProductModel product;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: size,
        height: size,
        color: const Color(0xFFF0F7EF),
        child: imageUrl == null || imageUrl.isEmpty
            ? Center(child: Text(product.imageEmoji, style: TextStyle(fontSize: size * 0.42)))
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(product.imageEmoji, style: TextStyle(fontSize: size * 0.42)),
                ),
              ),
      ),
    );
  }
}
