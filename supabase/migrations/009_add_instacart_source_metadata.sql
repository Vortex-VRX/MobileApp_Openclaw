-- Metadata for future allowed Instacart/marketplace imports.

alter table public.product_prices add column if not exists external_product_id text;
alter table public.product_prices add column if not exists external_storefront text;

insert into public.retailer_sources (id, retailer_code, retailer_name, market_area_id, source_url, source_type, data_access_status, notes, active) values
  ('instacart-manual-import-01880', 'instacart', 'Instacart Marketplace', 'wakefield-01880', 'https://www.instacart.com/', 'manual_or_approved_import', 'requires_approved_access', 'Use only data exported or collected through allowed interfaces. Instacart prices can differ from in-store prices and may vary by storefront, user, and time.', true)
on conflict (id) do update set
  source_url = excluded.source_url,
  source_type = excluded.source_type,
  data_access_status = excluded.data_access_status,
  notes = excluded.notes,
  active = excluded.active;
