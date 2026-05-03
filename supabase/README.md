# Supabase Setup

This folder contains the database setup for MobileApp_Codex.

## Files

- `migrations/001_initial_schema.sql` creates the database tables, indexes, triggers, and row-level security policies.
- `migrations/002_seed_catalog.sql` inserts the first grocery stores, categories, products, and prices.

## Active Supabase Project

```text
Project: Vortex-VRX's Project
Project ref: npnekplfuwnjlqvzwfdl
Project URL: https://npnekplfuwnjlqvzwfdl.supabase.co
Region: us-east-1
```

## Applied Migrations

These migrations have already been applied to the connected Supabase project:

```text
20260503001425 initial_schema
20260503001448 seed_catalog
```

## Flutter Runtime Config

The app reads live catalog data from Supabase when `SUPABASE_ANON_KEY` is provided. Without it, the app keeps using the bundled fallback catalog so development does not break.

Run the app with:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://npnekplfuwnjlqvzwfdl.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_PUBLIC_KEY
```

For release builds, pass the same values to `flutter build apk` or `flutter build appbundle`.

## App Credentials

The Flutter app should use:

- Supabase Project URL
- Supabase anon public key

Do not commit the service role key to GitHub. The service role key has admin-level database access and should only be used in private server-side tooling.

## Access Model

Public users can read:

- stores
- categories
- products
- product_prices

Signed-in users can manage only their own:

- profile
- cart_items
- favorites
- price_alerts

Product, store, and price updates should be done from an admin workflow or secure server process.
