import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
    this.size = 56,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.fit = BoxFit.cover,
  });

  final ProductModel product;
  final double size;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrl;
    final imageWidth = width ?? size;
    final imageHeight = height ?? size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: imageWidth,
        height: imageHeight,
        color: const Color(0xFFF0F7EF),
        child: imageUrl == null || imageUrl.isEmpty
            ? Center(child: Text(product.imageEmoji, style: TextStyle(fontSize: imageHeight * 0.36)))
            : Image.network(
                imageUrl,
                width: imageWidth,
                height: imageHeight,
                fit: fit,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(product.imageEmoji, style: TextStyle(fontSize: imageHeight * 0.36)),
                ),
              ),
      ),
    );
  }
}
