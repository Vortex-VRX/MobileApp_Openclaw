-- Temporary alignment while real daily prices are being collected.
-- Copies existing BJ's and Market Basket seed prices onto the active 01880 store records.

insert into public.product_prices (
  product_id,
  store_id,
  price,
  unit_price,
  unit_label,
  availability,
  discount_label,
  membership_price,
  source,
  source_url,
  market_area_id,
  price_type,
  observed_at,
  confidence_score
)
select
  product_id,
  case
    when store_id = 'bjs' then 'bjs-stoneham'
    when store_id = 'market-basket' then 'market-basket-reading'
  end as store_id,
  price,
  unit_price,
  unit_label,
  availability,
  discount_label,
  membership_price,
  'seed_demo_01880_placeholder' as source,
  source_url,
  'wakefield-01880' as market_area_id,
  price_type,
  now() as observed_at,
  0.50 as confidence_score
from public.product_prices
where store_id in ('bjs', 'market-basket')
on conflict (product_id, store_id) do update set
  price = excluded.price,
  unit_price = excluded.unit_price,
  unit_label = excluded.unit_label,
  availability = excluded.availability,
  discount_label = excluded.discount_label,
  membership_price = excluded.membership_price,
  source = excluded.source,
  market_area_id = excluded.market_area_id,
  price_type = excluded.price_type,
  observed_at = excluded.observed_at,
  confidence_score = excluded.confidence_score,
  last_updated = now();

update public.product_prices
set market_area_id = 'wakefield-01880'
where store_id in ('bjs-stoneham', 'market-basket-reading');

update public.stores
set active = false
where id in ('walmart', 'target', 'bjs', 'market-basket');
