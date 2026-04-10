class StoreModel {
  const StoreModel({
    required this.id,
    required this.name,
    required this.type,
    required this.distanceMiles,
    required this.hasPickup,
    required this.hasDelivery,
    required this.membershipRequired,
    required this.colorHex,
  });

  final String id;
  final String name;
  final String type;
  final double distanceMiles;
  final bool hasPickup;
  final bool hasDelivery;
  final bool membershipRequired;
  final int colorHex;
}
