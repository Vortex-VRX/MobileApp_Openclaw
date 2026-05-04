import 'price_option.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.packageInfo,
    required this.imageEmoji,
    required this.healthyScore,
    required this.description,
    required this.tags,
    required this.priceOptions,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String brand;
  final String category;
  final String packageInfo;
  final String imageEmoji;
  final String? imageUrl;
  final int healthyScore;
  final String description;
  final List<String> tags;
  final List<PriceOption> priceOptions;

  PriceOption get cheapestOption {
    final sorted = [...priceOptions]
      ..sort((a, b) {
        if (a.availability != b.availability) {
          return a.availability ? -1 : 1;
        }
        return _effectivePrice(a).compareTo(_effectivePrice(b));
      });
    return sorted.first;
  }

  PriceOption get bestUnitOption {
    final sorted = [...priceOptions]
      ..sort((a, b) {
        if (a.availability != b.availability) {
          return a.availability ? -1 : 1;
        }
        return a.unitPrice.compareTo(b.unitPrice);
      });
    return sorted.first;
  }

  double _effectivePrice(PriceOption option) => option.membershipPrice ?? option.price;
}
