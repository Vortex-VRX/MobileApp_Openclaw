import 'package:flutter/material.dart';

import '../../data/mock_data.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        children: [
          Text('Stores near you', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 6),
          const Text('Focused on BJ\'s, Market Basket, and Costco around 01880.', style: TextStyle(color: Color(0xFF667085), fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),
          ...stores.map((store) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE4E7EC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(store.colorHex),
                          child: Text(store.name.characters.first, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(store.name, style: theme.textTheme.titleMedium),
                              const SizedBox(height: 2),
                              Text(store.type, style: const TextStyle(color: Color(0xFF667085))),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0xFFE9F8E9), borderRadius: BorderRadius.circular(999)),
                          child: Text('${store.distanceMiles.toStringAsFixed(1)} mi', style: const TextStyle(color: Color(0xFF087D08), fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _tag(Icons.shopping_bag_outlined, store.hasPickup ? 'Pickup' : 'In-store'),
                        _tag(Icons.local_shipping_outlined, store.hasDelivery ? 'Delivery' : 'No delivery'),
                        _tag(Icons.card_membership_outlined, store.membershipRequired ? 'Membership' : 'Open pricing'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 14),
                    Row(
                      children: const [
                        Expanded(child: _InfoBox(label: 'Best use', value: 'Cart comparison')),
                        SizedBox(width: 10),
                        Expanded(child: _InfoBox(label: 'Status', value: 'Price tracking')),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _tag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFF7F8F6), borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF667085)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF7F8F6), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
