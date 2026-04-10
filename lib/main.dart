import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'widgets/app_shell.dart';

void main() {
  runApp(const GroceryPriceCompareRoot());
}

class GroceryPriceCompareRoot extends StatelessWidget {
  const GroceryPriceCompareRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery Price Compare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const GroceryPriceCompareApp(),
    );
  }
}
