-- Market-specific data pipeline for ZIP 01880.
-- This prepares the database for real retailer categories, source tracking, and daily price updates.

create table if not exists public.market_areas (
  id text primary key,
  zip_code text not null unique,
  city text not null,
  state text not null,
  label text not null,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.stores add column if not exists retailer_code text;
alter table public.stores add column if not exists market_area_id text references public.market_areas(id);
alter table public.stores add column if not exists source_url text;
alter table public.stores add column if not exists address_line_1 text;
alter table public.stores add column if not exists city text;
alter table public.stores add column if not exists state text;
alter table public.stores add column if not exists zip_code text;
alter table public.stores add column if not exists external_store_id text;
alter table public.stores add column if not exists last_price_check_at timestamptz;

alter table public.categories add column if not exists source_retailers text[] not null default '{}';
alter table public.categories add column if not exists food_only boolean not null default true;

alter table public.products add column if not exists source_status text not null default 'seed_demo';
alter table public.products add column if not exists source_url text;
alter table public.products add column if not exists last_verified_at timestamptz;

alter table public.product_prices add column if not exists source_url text;
alter table public.product_prices add column if not exists market_area_id text references public.market_areas(id);
alter table public.product_prices add column if not exists price_type text not null default 'regular';
alter table public.product_prices add column if not exists observed_at timestamptz not null default now();
alter table public.product_prices add column if not exists confidence_score numeric(3,2) not null default 1.00 check (confidence_score >= 0 and confidence_score <= 1);

create table if not exists public.retailer_sources (
  id text primary key,
  retailer_code text not null,
  retailer_name text not null,
  market_area_id text references public.market_areas(id),
  source_url text not null,
  source_type text not null,
  data_access_status text not null default 'needs_review',
  notes text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.price_update_runs (
  id uuid primary key default gen_random_uuid(),
  market_area_id text not null references public.market_areas(id),
  run_type text not null default 'manual_review',
  status text not null default 'started',
  started_at timestamptz not null default now(),
  finished_at timestamptz,
  stores_checked integer not null default 0,
  products_checked integer not null default 0,
  prices_updated integer not null default 0,
  notes text
);

create table if not exists public.price_history (
  id uuid primary key default gen_random_uuid(),
  product_id text not null references public.products(id) on delete cascade,
  store_id text not null references public.stores(id) on delete cascade,
  market_area_id text references public.market_areas(id),
  price numeric(10,2) not null check (price >= 0),
  unit_price numeric(10,2) not null check (unit_price >= 0),
  unit_label text not null,
  availability boolean not null default true,
  discount_label text,
  membership_price numeric(10,2) check (membership_price is null or membership_price >= 0),
  price_type text not null default 'regular',
  source text not null default 'manual_review',
  source_url text,
  observed_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists public.retailer_category_map (
  id uuid primary key default gen_random_uuid(),
  retailer_code text not null,
  category_id text not null references public.categories(id) on delete cascade,
  retailer_category_name text not null,
  source_url text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (retailer_code, category_id, retailer_category_name)
);

create index if not exists stores_market_area_id_idx on public.stores(market_area_id);
create index if not exists stores_retailer_code_idx on public.stores(retailer_code);
create index if not exists product_prices_market_area_id_idx on public.product_prices(market_area_id);
create index if not exists price_history_product_store_idx on public.price_history(product_id, store_id, observed_at desc);
create index if not exists price_history_market_area_idx on public.price_history(market_area_id, observed_at desc);
create index if not exists price_update_runs_market_area_idx on public.price_update_runs(market_area_id, started_at desc);

insert into public.market_areas (id, zip_code, city, state, label, active) values
  ('wakefield-01880', '01880', 'Wakefield', 'MA', 'Wakefield, MA 01880', true)
on conflict (id) do update set zip_code = excluded.zip_code, city = excluded.city, state = excluded.state, label = excluded.label, active = excluded.active;

update public.stores set active = false where id in ('walmart', 'target');

insert into public.stores (id, retailer_code, market_area_id, name, type, distance_miles, has_pickup, has_delivery, membership_required, color_hex, active, source_url, address_line_1, city, state, zip_code, external_store_id) values
  ('bjs-stoneham', 'bjs', 'wakefield-01880', 'BJ''s Wholesale Club', 'Wholesale Club', 5.0, true, true, true, '#B71C1C', true, 'https://www.bjs.com/cl/stoneham/0050', '85 Cedar St.', 'Stoneham', 'MA', '02180', '0050'),
  ('market-basket-reading', 'market_basket', 'wakefield-01880', 'Market Basket', 'Supermarket', 3.7, false, false, false, '#16833C', true, 'https://www.shopmarketbasket.com/store-locations/reading-massachusetts-market-basket-60', '30 General Way', 'Reading', 'MA', '01867', '60'),
  ('costco-danvers', 'costco', 'wakefield-01880', 'Costco Wholesale', 'Warehouse Club', 11.0, false, false, true, '#005DAA', true, 'https://www.costco.com/warehouse-locations/danvers-ma-301.html', '11 Newbury St', 'Danvers', 'MA', '01923', '301')
on conflict (id) do update set retailer_code = excluded.retailer_code, market_area_id = excluded.market_area_id, name = excluded.name, type = excluded.type, distance_miles = excluded.distance_miles, has_pickup = excluded.has_pickup, has_delivery = excluded.has_delivery, membership_required = excluded.membership_required, color_hex = excluded.color_hex, active = excluded.active, source_url = excluded.source_url, address_line_1 = excluded.address_line_1, city = excluded.city, state = excluded.state, zip_code = excluded.zip_code, external_store_id = excluded.external_store_id;
