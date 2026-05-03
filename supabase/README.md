# Supabase Setup

This folder contains the database setup for MobileApp_Codex.

## Files

- `migrations/001_initial_schema.sql` creates the database tables, indexes, triggers, and row-level security policies.
- `migrations/002_seed_catalog.sql` inserts the first grocery stores, categories, products, and prices.

## Recommended Supabase Project

Create one Supabase project for the app, for example:

```text
mobileapp-codex
```

Use Supabase Auth plus PostgreSQL tables.

## How To Apply The Database

Option 1: Supabase Dashboard

1. Open the Supabase project.
2. Go to SQL Editor.
3. Run `001_initial_schema.sql`.
4. Run `002_seed_catalog.sql`.

Option 2: Supabase CLI

```bash
supabase link --project-ref YOUR_PROJECT_REF
supabase db push
```

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
