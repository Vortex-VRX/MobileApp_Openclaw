import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_state.dart';
import 'core/app_theme.dart';
import 'core/supabase_config.dart';
import 'data/mock_data.dart';
import 'data/supabase_catalog_repository.dart';
import 'widgets/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadCatalogFromSupabase();
  runApp(const GroceryPriceCompareRoot());
}

Future<void> _loadCatalogFromSupabase() async {
  if (!SupabaseConfig.isConfigured) {
    return;
  }

  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    final repository = SupabaseCatalogRepository(Supabase.instance.client);
    final catalog = await repository.loadCatalog();
    replaceCatalogData(catalog);
  } catch (_) {
    // Keep the bundled catalog available if Supabase is unavailable.
  }
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
