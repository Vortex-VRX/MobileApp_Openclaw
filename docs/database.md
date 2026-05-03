# Database

MobileApp_Codex uses Supabase as the active database and backend platform.

## Active Database

- Platform: Supabase
- Database: PostgreSQL
- Auth: Supabase Auth
- App access: Supabase Flutter client
- Project ref: `npnekplfuwnjlqvzwfdl`

## Database Files

- `supabase/migrations/001_initial_schema.sql`
- `supabase/migrations/002_seed_catalog.sql`
- `supabase/migrations/003_catalog_views_and_cart_totals.sql`
- `supabase/README.md`

## Main Tables

- `stores`
- `categories`
- `products`
- `product_prices`
- `profiles`
- `cart_items`
- `favorites`
- `price_alerts`

## Backend Helpers

- `product_catalog` view returns products with category names and nested price data.
- `compare_cart(product_ids text[])` returns store totals for a requested cart.

## Current Seed Data

- 4 stores
- 5 categories
- 6 products
- 24 product prices

## Notes

Firebase is not used by this project. Keep database work in the `supabase/` folder so the app has one clear backend path.
