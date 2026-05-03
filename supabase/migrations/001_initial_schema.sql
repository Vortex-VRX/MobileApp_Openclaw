-- Initial Supabase schema for MobileApp_Codex grocery price comparison app.
-- Run this in the Supabase SQL editor or with the Supabase CLI.

create extension if not exists pgcrypto;

create table if not exists public.stores (
  id text primary key,
  name text not null,
  type text not null,
  distance_miles numeric(6,2) not null default 0,
  has_pickup boolean not null default false,
  has_delivery boolean not null default false,
  membership_required boolean not null default false,
  color_hex text not null default '#2E7D32',
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.categories (
  id text primary key,
  title text not null,
  icon text not null,
  item_count integer not null default 0,
  sort_order integer not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.products (
  id text primary key,
  name text not null,
  brand text not null,
  category_id text not null references public.categories(id),
  package_info text not null,
  image_emoji text not null,
  healthy_score integer not null default 0 check (healthy_score >= 0 and healthy_score <= 100),
  description text not null,
  tags text[] not null default '{}',
  searchable_keywords text[] not null default '{}',
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.product_prices (
  id uuid primary key default gen_random_uuid(),
  product_id text not null references public.products(id) on delete cascade,
  store_id text not null references public.stores(id) on delete cascade,
  price numeric(10,2) not null check (price >= 0),
  unit_price numeric(10,2) not null check (unit_price >= 0),
  unit_label text not null,
  availability boolean not null default true,
  discount_label text,
  membership_price numeric(10,2) check (membership_price is null or membership_price >= 0),
  source text not null default 'manual',
  last_updated timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (product_id, store_id)
);

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  email text,
  home_zip_code text,
  preferred_stores text[] not null default '{}',
  premium boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.cart_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  product_id text not null references public.products(id) on delete cascade,
  quantity integer not null default 1 check (quantity > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, product_id)
);

create table if not exists public.favorites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  product_id text not null references public.products(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (user_id, product_id)
);

create table if not exists public.price_alerts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  product_id text not null references public.products(id) on delete cascade,
  target_price numeric(10,2) not null check (target_price >= 0),
  enabled boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger stores_set_updated_at before update on public.stores for each row execute function public.set_updated_at();
create trigger categories_set_updated_at before update on public.categories for each row execute function public.set_updated_at();
create trigger products_set_updated_at before update on public.products for each row execute function public.set_updated_at();
create trigger product_prices_set_updated_at before update on public.product_prices for each row execute function public.set_updated_at();
create trigger profiles_set_updated_at before update on public.profiles for each row execute function public.set_updated_at();
create trigger cart_items_set_updated_at before update on public.cart_items for each row execute function public.set_updated_at();
create trigger price_alerts_set_updated_at before update on public.price_alerts for each row execute function public.set_updated_at();

create index if not exists products_category_id_idx on public.products(category_id);
create index if not exists products_active_idx on public.products(active);
create index if not exists products_keywords_idx on public.products using gin(searchable_keywords);
create index if not exists product_prices_product_id_idx on public.product_prices(product_id);
create index if not exists product_prices_store_id_idx on public.product_prices(store_id);
create index if not exists cart_items_user_id_idx on public.cart_items(user_id);
create index if not exists favorites_user_id_idx on public.favorites(user_id);
create index if not exists price_alerts_user_id_idx on public.price_alerts(user_id);
create index if not exists price_alerts_enabled_idx on public.price_alerts(enabled);

alter table public.stores enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.product_prices enable row level security;
alter table public.profiles enable row level security;
alter table public.cart_items enable row level security;
alter table public.favorites enable row level security;
alter table public.price_alerts enable row level security;

create policy "Public stores are readable" on public.stores for select using (active = true);
create policy "Public categories are readable" on public.categories for select using (active = true);
create policy "Public products are readable" on public.products for select using (active = true);
create policy "Public prices are readable" on public.product_prices for select using (true);

create policy "Users can read own profile" on public.profiles for select using (auth.uid() = id);
create policy "Users can insert own profile" on public.profiles for insert with check (auth.uid() = id);
create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);

create policy "Users can read own cart" on public.cart_items for select using (auth.uid() = user_id);
create policy "Users can insert own cart" on public.cart_items for insert with check (auth.uid() = user_id);
create policy "Users can update own cart" on public.cart_items for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users can delete own cart" on public.cart_items for delete using (auth.uid() = user_id);

create policy "Users can read own favorites" on public.favorites for select using (auth.uid() = user_id);
create policy "Users can insert own favorites" on public.favorites for insert with check (auth.uid() = user_id);
create policy "Users can delete own favorites" on public.favorites for delete using (auth.uid() = user_id);

create policy "Users can read own alerts" on public.price_alerts for select using (auth.uid() = user_id);
create policy "Users can insert own alerts" on public.price_alerts for insert with check (auth.uid() = user_id);
create policy "Users can update own alerts" on public.price_alerts for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users can delete own alerts" on public.price_alerts for delete using (auth.uid() = user_id);
