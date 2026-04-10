import 'package:flutter/material.dart';

import 'core/app_state.dart';
import 'core/app_theme.dart';
import 'widgets/app_shell.dart';

void main() {
  runApp(const GroceryPriceCompareRoot());
}

class GroceryPriceCompareRoot extends StatefulWidget {
  const GroceryPriceCompareRoot({super.key});

  @override
  State<GroceryPriceCompareRoot> createState() => _GroceryPriceCompareRootState();
}

class _GroceryPriceCompareRootState extends State<GroceryPriceCompareRoot> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _appState,
      child: MaterialApp(
        title: 'Grocery Price Compare',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const GroceryPriceCompareApp(),
      ),
    );
  }
}
