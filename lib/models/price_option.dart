class PriceOption {
  const PriceOption({
    required this.storeId,
    required this.price,
    required this.unitPrice,
    required this.unitLabel,
    required this.availability,
    this.discountLabel,
    this.membershipPrice,
  });

  final String storeId;
  final double price;
  final double unitPrice;
  final String unitLabel;
  final bool availability;
  final String? discountLabel;
  final double? membershipPrice;
}
