-- Backend helpers for product catalog reads and cart total comparison.

create or replace view public.product_catalog as
select
  p.id,
  p.name,
  p.brand,
  p.category_id,
  c.title as category_title,
  p.package_info,
  p.image_emoji,
  p.healthy_score,
  p.description,
  p.tags,
  p.searchable_keywords,
  p.active,
  coalesce(
    jsonb_agg(
      jsonb_build_object(
        'store_id', pp.store_id,
        'store_name', s.name,
        'price', pp.price,
        'unit_price', pp.unit_price,
        'unit_label', pp.unit_label,
        'availability', pp.availability,
        'discount_label', pp.discount_label,
        'membership_price', pp.membership_price,
        'source', pp.source,
        'last_updated', pp.last_updated
      ) order by coalesce(pp.membership_price, pp.price), pp.price
    ) filter (where pp.id is not null),
    '[]'::jsonb
  ) as prices
from public.products p
join public.categories c on c.id = p.category_id
left join public.product_prices pp on pp.product_id = p.id
left join public.stores s on s.id = pp.store_id
where p.active = true
group by p.id, c.title;

create or replace function public.compare_cart(product_ids text[])
returns table (
  store_id text,
  store_name text,
  item_count integer,
  total numeric,
  unavailable_count integer,
  distance_miles numeric,
  has_pickup boolean,
  has_delivery boolean,
  membership_required boolean
)
language sql
stable
as $$
  with requested_products as (
    select unnest(product_ids) as product_id
  ),
  store_totals as (
    select
      s.id as store_id,
      s.name as store_name,
      count(rp.product_id)::integer as item_count,
      coalesce(sum(coalesce(pp.membership_price, pp.price)), 0)::numeric(10,2) as total,
      count(rp.product_id) filter (where pp.availability is not true)::integer as unavailable_count,
      s.distance_miles,
      s.has_pickup,
      s.has_delivery,
      s.membership_required
    from public.stores s
    cross join requested_products rp
    left join public.product_prices pp
      on pp.store_id = s.id
     and pp.product_id = rp.product_id
    where s.active = true
    group by s.id, s.name, s.distance_miles, s.has_pickup, s.has_delivery, s.membership_required
  )
  select *
  from store_totals
  order by unavailable_count asc, total asc, distance_miles asc;
$$;

grant select on public.product_catalog to anon, authenticated;
grant execute on function public.compare_cart(text[]) to anon, authenticated;
