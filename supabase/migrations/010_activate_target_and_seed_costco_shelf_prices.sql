update public.stores
set active = true,
    type = 'Grocery & retail',
    distance_miles = 3.1,
    has_pickup = true,
    has_delivery = false,
    membership_required = false,
    color_hex = '#CC0000',
    market_area_id = coalesce(market_area_id, 'wakefield-01880')
where id = 'target';

delete from public.product_prices
where store_id = 'costco-danvers'
  and source = 'manual_seed';

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
  market_area_id,
  price_type,
  observed_at,
  last_updated,
  confidence_score
)
select
  product_id,
  'costco-danvers',
  round((coalesce(membership_price, price) * 0.96)::numeric, 2),
  round((unit_price * 0.96)::numeric, 2),
  unit_label,
  availability,
  'Warehouse comparison seed',
  round((coalesce(membership_price, price) * 0.92)::numeric, 2),
  'manual_seed',
  coalesce(market_area_id, 'wakefield-01880'),
  'regular',
  now(),
  now(),
  0.50
from public.product_prices
where store_id = 'bjs-stoneham';

update public.categories c
set item_count = counts.item_count
from (
  select category_id, count(*)::int as item_count
  from public.products
  where active = true
  group by category_id
) counts
where counts.category_id = c.id;
