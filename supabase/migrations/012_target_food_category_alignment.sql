insert into public.categories (id, title, icon, item_count, sort_order, active, source_retailers, food_only)
values
  ('grocery-deals', 'Grocery Deals', '🏷️', 0, 5, true, array['target'], true),
  ('frozen-foods', 'Frozen Foods', '🧊', 0, 10, true, array['target'], true),
  ('snacks', 'Snacks', '🍿', 0, 20, true, array['target'], true),
  ('meat', 'Fresh Meat & Seafood', '🥩', 0, 30, true, array['target'], true),
  ('produce', 'Produce', '🥦', 0, 40, true, array['target'], true),
  ('bakery', 'Bakery & Bread', '🍞', 0, 50, true, array['target'], true),
  ('beverages', 'Beverages', '🥤', 0, 60, true, array['target'], true),
  ('pantry', 'Pantry', '🥫', 0, 70, true, array['target'], true),
  ('breakfast', 'Breakfast & Cereal', '🥣', 0, 80, true, array['target'], true),
  ('dairy', 'Dairy, Eggs & Cheese', '🧀', 0, 90, true, array['target'], true),
  ('deli', 'Deli', '🥪', 0, 100, true, array['target'], true),
  ('international-foods', 'International Foods', '🌎', 0, 110, true, array['target'], true),
  ('candy', 'Candy', '🍬', 0, 120, true, array['target'], true),
  ('coffee', 'Coffee', '☕', 0, 130, true, array['target'], true),
  ('baby-food', 'Baby Food', '🍼', 0, 140, true, array['target'], true)
on conflict (id) do update
set title = excluded.title,
    icon = excluded.icon,
    sort_order = excluded.sort_order,
    active = true,
    source_retailers = array(select distinct unnest(coalesce(public.categories.source_retailers, '{}'::text[]) || excluded.source_retailers)),
    food_only = true,
    updated_at = now();

update public.categories
set active = false,
    updated_at = now()
where id in ('seafood', 'dairy-frozen', 'prepared-foods', 'baking-ingredients', 'protein-nutrition', 'cheese', 'sushi');

insert into public.retailer_category_map (retailer_code, category_id, retailer_category_name, source_url, active)
values
  ('target', 'grocery-deals', 'Grocery Deals', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'frozen-foods', 'Frozen Foods', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'snacks', 'Snacks', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'meat', 'Fresh Meat & Seafood', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'produce', 'Produce', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'bakery', 'Bakery & Bread', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'beverages', 'Beverages', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'pantry', 'Pantry', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'breakfast', 'Breakfast & Cereal', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'dairy', 'Dairy, Eggs & Cheese', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'deli', 'Deli', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'international-foods', 'International Foods', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'candy', 'Candy', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'coffee', 'Coffee', 'https://www.target.com/c/grocery/-/N-5xt1a', true),
  ('target', 'baby-food', 'Baby Food', 'https://www.target.com/c/grocery/-/N-5xt1a', true)
on conflict do nothing;

update public.categories c
set item_count = coalesce(counts.item_count, 0),
    updated_at = now()
from (
  select c2.id, count(p.id)::int as item_count
  from public.categories c2
  left join public.products p on p.category_id = c2.id and p.active = true
  group by c2.id
) counts
where counts.id = c.id;
