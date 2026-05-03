# Database

MobileApp_Codex uses Supabase as the active database and backend platform.

## Active Database

- Platform: Supabase
- Database: PostgreSQL
- Auth: Supabase Auth
- App access: Supabase Flutter client

## Database Files

- `supabase/migrations/001_initial_schema.sql`
- `supabase/migrations/002_seed_catalog.sql`
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

## Notes

Firebase is not used by this project. Keep database work in the `supabase/` folder so the app has one clear backend path.
