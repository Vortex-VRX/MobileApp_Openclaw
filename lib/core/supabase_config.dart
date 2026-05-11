class SupabaseConfig {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://npnekplfuwnjlqvzwfdl.supabase.co',
  );

  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_A8PrphNrGB1A85OCXx-4LA_9WnEPG1H',
  );

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
