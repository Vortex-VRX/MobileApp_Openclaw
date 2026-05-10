create table if not exists public.apify_import_runs (
  id uuid primary key default gen_random_uuid(),
  retailer_code text not null,
  store_id text not null references public.stores(id),
  market_area_id text references public.market_areas(id),
  zip_code text not null,
  actor_id text not null,
  status text not null default 'started',
  input jsonb not null default '{}'::jsonb,
  dataset_item_count integer not null default 0,
  imported_count integer not null default 0,
  skipped_count integer not null default 0,
  error_message text,
  started_at timestamptz not null default now(),
  finished_at timestamptz
);

create table if not exists public.apify_import_items (
  id uuid primary key default gen_random_uuid(),
  run_id uuid not null references public.apify_import_runs(id) on delete cascade,
  retailer_code text not null,
  store_id text not null references public.stores(id),
  external_product_id text,
  product_id text references public.products(id),
  source_url text,
  raw_item jsonb not null,
  normalized_item jsonb not null default '{}'::jsonb,
  imported boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists apify_import_runs_retailer_started_idx on public.apify_import_runs(retailer_code, started_at desc);
create index if not exists apify_import_items_run_idx on public.apify_import_items(run_id);
create index if not exists apify_import_items_external_idx on public.apify_import_items(retailer_code, external_product_id);

insert into public.retailer_sources (id, retailer_code, retailer_name, market_area_id, source_url, source_type, data_access_status, notes, active)
values (
  'apify-target-01880',
  'target',
  'Target',
  'wakefield-01880',
  'https://apify.com/',
  'apify_actor',
  'configured',
  'Apify-powered Target grocery import for ZIP 01880. Requires APIFY_API_TOKEN secret and selected Target actor input.',
  true
)
on conflict (id) do update
set source_type = excluded.source_type,
    data_access_status = excluded.data_access_status,
    notes = excluded.notes,
    active = true,
    updated_at = now();

update public.stores
set active = true,
    retailer_code = 'target',
    market_area_id = coalesce(market_area_id, 'wakefield-01880'),
    source_url = 'https://www.target.com/c/grocery/-/N-5xt1a',
    last_price_check_at = null
where id = 'target';
